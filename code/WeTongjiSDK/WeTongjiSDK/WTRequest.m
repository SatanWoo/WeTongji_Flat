//
//  WTRequest.m
//  WeTongjiSDK
//
//  Created by 王 紫川 on 13-3-8.
//  Copyright (c) 2013年 WeTongji. All rights reserved.
//

#import "WTRequest.h"
#import "NSString+URLEncoding.h"
#import "NSString+WTSDKAddition.h"
#import "JSON.h"
#import "NSError+WTSDKClientErrorGenerator.h"
#import <Security/Security.h>
#import "Base64.h"

#define DEVICE_IDENTIFIER   @"iOS"
#define API_VERSION         @"3.0"

@interface WTRequest()

@property (nonatomic, copy)     WTSuccessCompletionBlock successCompletionBlock;
@property (nonatomic, copy)     WTFailureCompletionBlock failureCompletionBlock;
@property (nonatomic, copy)     WTSuccessCompletionBlock preSuccessCompletionBlock;
@property (nonatomic, copy)     NSString *HTTPMethod;

@property (nonatomic, strong)   NSMutableDictionary *params;
@property (nonatomic, strong)   NSMutableDictionary *postValue;
@property (nonatomic, strong)   UIImage *uploadImage;

@property (nonatomic, assign)   BOOL valid;
@property (nonatomic, strong)   NSError *error;

@end

@implementation WTRequest

#pragma mark - Constructors

+ (WTRequest *)requestWithSuccessBlock:(WTSuccessCompletionBlock)success
                          failureBlock:(WTFailureCompletionBlock)failure {
    WTRequest *result = [[WTRequest alloc] init];
    result.successCompletionBlock = success;
    result.failureCompletionBlock = failure;
    result.HTTPMethod = HttpMethodGET;
    return result;
}

- (id)init {
    self = [super init];
    if (self) {
        self.valid = true;
    }
    return self;
}

#pragma mark - Properties

- (NSMutableDictionary *)postValue
{
    if (!_postValue) {
        _postValue = [[NSMutableDictionary alloc] init];
    }
    return _postValue;
}

- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [[NSMutableDictionary alloc] init];
        _params[@"D"] = DEVICE_IDENTIFIER;
        //NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        _params[@"V"] = API_VERSION;
    }
    return _params;
}

- (NSString *)queryString {
    NSArray *names = [self.params allKeys];
    NSArray *sortedNames = [names sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        return [str1 compare:str2];
    }];
    
    NSMutableString *result = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i < [sortedNames count]; i++) {
        if (i > 0)
            [result appendString:@"&"];
        NSString *name = sortedNames[i];
        NSString *parameter = self.params[name];
        [result appendString:[NSString stringWithFormat:@"%@=%@", [name URLEncodedString],
                              [parameter URLEncodedString]]];
    }
    
    return result;
}

#pragma mark - Logic methods

- (void)addHashParam {
    // 3.0 API 不再使用
    return;
    NSArray *names = [self.params allKeys];
    NSArray *sortedNames = [names sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        return [str1 compare:str2];
    }];
    
    NSMutableString *result = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i < [sortedNames count]; i++) {
        if (i > 0)
            [result appendString:@"&"];
        NSString *name = sortedNames[i];
        NSString *parameter = self.params[name];
        [result appendString:[NSString stringWithFormat:@"%@=%@", [name URLEncodedString],
                              [parameter URLEncodedString]]];
    }
    NSString *md5 = [result md5HexDigest];
    self.params[@"H"] = md5;
}

- (void)addUserIDAndSessionParams {
    if ([NSUserDefaults getCurrentUserID] && [NSUserDefaults getCurrentUserSession]) {
        self.params[@"U"] = [NSUserDefaults getCurrentUserID];
        self.params[@"S"] = [NSUserDefaults getCurrentUserSession];
    } else {
        self.valid = false;
        NSError *error = [NSError createErrorWithErrorCode:ErrorCodeNeedUserLogin];
        self.error = error;
    }
}

- (SecKeyRef)getPublicKeyRef {
    NSString *keyPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
    NSData *keyData = [[NSData alloc] initWithContentsOfFile:keyPath];
    SecCertificateRef myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)keyData);
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(myCertificate, myPolicy, &myTrust);
    SecTrustResultType trustResult;
    if (status == noErr) {
        status = SecTrustEvaluate(myTrust, &trustResult);
    }
    SecKeyRef result = SecTrustCopyPublicKey(myTrust);
    
    CFRelease(myPolicy);
    CFRelease(myTrust);
    
    return result;
}

- (NSString *)RSAEncryptText:(NSString *)plainText {
    
    SecKeyRef key = [self getPublicKeyRef];
    
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0 * 0, cipherBufferSize);
    
    NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t blockSize = cipherBufferSize;
    size_t blockCount = (size_t)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [NSMutableData dataWithCapacity:0];
    
    for (int i = 0; i < blockCount; i++) {
        
        int bufferSize = MIN(blockSize, [plainTextBytes length] - i * blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        
        OSStatus status = SecKeyEncrypt(key,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        
        if (status == noErr) {
            NSData *encryptedBytes = [NSData dataWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
            
        } else {
            
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    if (cipherBuffer)
        free(cipherBuffer);
        
    NSString *encryptResult = [NSString stringWithFormat:@"%@", [encryptedData base64EncodedString]];
    
    CFRelease(key);
    
    return encryptResult;
}

+ (NSString *)generateUserIDArrayString:(NSArray *)userIDArray {
    if (userIDArray.count == 0)
        return @"";
    NSMutableString *userIDArrayString = [NSMutableString string];
    for (NSString *userID in userIDArray) {
        [userIDArrayString appendFormat:@"%@,", userID];
    }
    [userIDArrayString deleteCharactersInRange:NSMakeRange(userIDArrayString.length - 1, 1)];
    NSLog(@"userIDArrayString:%@", userIDArrayString);
    return userIDArrayString;
}

+ (NSString *)convertModelTypeStringFromModelType:(WTSDKModelType)type {
    NSString *result = @"";
    switch (type) {
        case WTSDKActivity:
            result = @"Activity";
            break;
        case WTSDKBillboard:
            result = @"Story";
            break;
        case WTSDKInformation:
            result = @"Information";
            break;
        case WTSDKStar:
            result = @"Person";
            break;
        case WTSDKOrganization:
            result = @"Account";
            break;
        case WTSDKUser:
            result = @"User";
            break;
        case WTSDKCourse:
            result = @"Course";
            break;
        default:
            break;
    }
    return result;
}

#pragma mark - Configure API parameters
#pragma mark User API

- (void)loginWithStudentNumber:(NSString *)studentNumber
                      password:(NSString *)password {
    self.params[@"M"] = @"User.LogOn";
    self.params[@"NO"] = studentNumber;
    if ([API_VERSION isEqualToString:@"3.0"])
        self.params[@"Password"] = [self RSAEncryptText:password];
    else {
        self.params[@"Password"] = password;
    }
    [self setPreSuccessCompletionBlock: ^(id responseData) {
        [NSUserDefaults setCurrentUserID:responseData[@"User"][@"UID"] session:responseData[@"Session"]];
    }];
    [self addHashParam];
}

- (void)activateUserWithStudentNumber:(NSString *)studentNumber
                             password:(NSString *)password
                                 name:(NSString *)name {
    self.params[@"M"] = @"User.Active";
    self.params[@"NO"] = studentNumber;
    if ([API_VERSION isEqualToString:@"3.0"])
        self.params[@"Password"] = [self RSAEncryptText:password];
    else {
        self.params[@"Password"] = password;
    }
    self.params[@"Name"] = name;
    [self addHashParam];
}

- (void)updateUserEmail:(NSString *)email
              weiboName:(NSString *)weibo
               phoneNum:(NSString *)phone
              qqAccount:(NSString *)qq
                  motto:(NSString *)motto
                   dorm:(NSString *)dorm {
    self.params[@"M"] = @"User.Update";
    [self addUserIDAndSessionParams];
    
    NSMutableDictionary *itemDict = [[NSMutableDictionary alloc] init];
    // if (displayName != nil) itemDict[@"DisplayName"] = displayName;
    if (email != nil) itemDict[@"Email"] = email;
    if (weibo != nil) itemDict[@"SinaWeibo"] = weibo;
    if (phone != nil) itemDict[@"Phone"] = phone;
    if (qq != nil) itemDict[@"QQ"] = qq;
    if (motto != nil) itemDict[@"Words"] = motto;
    if (dorm != nil) itemDict[@"Room"] = dorm;
    NSDictionary *userDict = @{@"User": itemDict};
    NSString *userJSONStr = [userDict JSONRepresentation];
    
    [self addHashParam];
    (self.postValue)[@"User"] = userJSONStr;
    self.HTTPMethod = HttpMethodPOST;
}

- (void)updatePassword:(NSString *)newPassword
           oldPassword:(NSString *)oldPassword {
    self.params[@"M"] = @"User.Update.Password";
    
    [self addUserIDAndSessionParams];
    if ([API_VERSION isEqualToString:@"3.0"]) {
        self.params[@"New"] = [self RSAEncryptText:newPassword];
        self.params[@"Old"] = [self RSAEncryptText:oldPassword];
    } else {
        self.params[@"New"] = newPassword;
        self.params[@"Old"] = oldPassword;
    }
    
    [self addHashParam];
    
    [self setPreSuccessCompletionBlock: ^(id responseData) {
        [NSUserDefaults setCurrentUserID:responseData[@"User"][@"UID"] session:responseData[@"Session"]];
    }];
}

- (void)updateUserAvatar:(UIImage *)image {
    self.params[@"M"] = @"User.Update.Avatar";
    [self addUserIDAndSessionParams];
    self.uploadImage = image;
    self.HTTPMethod = HttpMethodUpLoadImage;
    [self addHashParam];
}

- (void)getUserInformation {
    self.params[@"M"] = @"User.Get";
    [self addUserIDAndSessionParams];
    [self addHashParam];
}

- (void)resetPasswordWithStudentNumber:(NSString *)studentNumber
                                  name:(NSString *)name {
    self.params[@"M"] = @"User.Reset.Password";
    self.params[@"NO"] = studentNumber;
    self.params[@"Name"] = name;
    [self addHashParam];
}

#pragma mark Schedule API

- (void)getScheduleWithBeginDate:(NSDate *)begin endDate:(NSDate *)end {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Schedule.Get";
    self.params[@"Begin"] = [NSString standardDateStringCovertFromDate:begin];
    self.params[@"End"] = [NSString standardDateStringCovertFromDate:end];
    [self addHashParam];
}

- (void)getScheduleSetting {
    self.params[@"M"] = @"SchoolYear.Setting";
    [self addHashParam];
}

#pragma mark Activity API

+ (NSString *)generateActivityShowTypesParam:(NSArray *)showTypesArray {
    if (!showTypesArray)
        return [NSString stringWithFormat:@"1,2,3,4"];
    
    NSMutableString *showTypesString = [NSMutableString string];
    for (int i = 0; i < showTypesArray.count; i++) {
        NSNumber *showTypeNumber = showTypesArray[i];
        if (showTypeNumber.boolValue) {
            [showTypesString appendFormat:@"%@%d", ([showTypesString isEqualToString:@""] ? @"" : @","), i + 1];
        }
    }
    return showTypesString;
}

#define GetActivitySortMethodLikeAsc        @"`like` ASC"
#define GetActivitySortMethodBeginAsc       @"`begin` ASC"
#define GetActivitySortMethodPublishAsc     @"`created_at` ASC"
#define GetActivitySortMethodLikeDesc       @"`like` DESC"
#define GetActivitySortMethodBeginDesc      @"`begin` DESC"
#define GetActivitySortMethodPublishDesc    @"`created_at` DESC"

typedef enum {
    ActivityOrderByPublishDate  = 1 << 0,
    ActivityOrderByPopularity   = 1 << 1,
    ActivityOrderByStartDate    = 1 << 2,
} ActivityOrderMethod;

+ (BOOL)shouldActivityOrderByDesc:(NSUInteger)orderMethod
                     smartOrder:(BOOL)smartOrder
                     showExpire:(BOOL)showExpire {
    BOOL result = NO;
    switch (orderMethod) {
        case ActivityOrderByPublishDate:
        {
            result = smartOrder;
        }
            break;
        case ActivityOrderByPopularity:
        {
            result = smartOrder;
        }
            break;
        case ActivityOrderByStartDate:
        {
            result = (showExpire && smartOrder) || (!showExpire && !smartOrder);
        }
            break;
        default:
            break;
    }
    return result;
}

+ (NSString *)generateActivityOrderMethodParam:(NSUInteger)orderMethod
                                    smartOrder:(BOOL)smartOrder
                                    showExpire:(BOOL)showExpire {
    NSString *result = nil;
    BOOL shouldOrderByDesc = [WTRequest shouldActivityOrderByDesc:orderMethod
                                                       smartOrder:smartOrder
                                                       showExpire:showExpire];
    switch (orderMethod) {
        case ActivityOrderByPublishDate:
        {
            result = shouldOrderByDesc ? GetActivitySortMethodPublishDesc : GetActivitySortMethodPublishAsc;
        }
            break;
        case ActivityOrderByPopularity:
        {
            result = shouldOrderByDesc ? GetActivitySortMethodLikeDesc : GetActivitySortMethodLikeAsc;
        }
            break;
        case ActivityOrderByStartDate:
        {
            result = shouldOrderByDesc ? GetActivitySortMethodBeginDesc : GetActivitySortMethodBeginAsc;
        }
            break;
        default:
            break;
    }
    return result;
}

- (void)getActivitiesInTypes:(NSArray *)showTypesArray
                 orderMethod:(NSUInteger)orderMethod
                  smartOrder:(BOOL)smartOrder
                  showExpire:(BOOL)showExpire
                        page:(NSUInteger)page
             scheduledByUser:(NSString *)userID {
    [self addUserIDAndSessionParams];
    
    self.params[@"M"] = @"Activities.Get.ByUser";
    
    self.params[@"Channel_Ids"] = [WTRequest generateActivityShowTypesParam:showTypesArray];
    
    self.params[@"Sort"] = [WTRequest generateActivityOrderMethodParam:orderMethod
                                                            smartOrder:smartOrder
                                                            showExpire:showExpire];
    
    self.params[@"Expire"] = [NSString stringWithFormat:@"%d", showExpire];
    
    self.params[@"P"] = [NSString stringWithFormat:@"%d", page];
    
    if (userID)
        self.params[@"UID"] = userID;
    
    [self addHashParam];
}

- (void)getActivitiesInTypes:(NSArray *)showTypesArray
                 orderMethod:(NSUInteger)orderMethod
                  smartOrder:(BOOL)smartOrder
                  showExpire:(BOOL)showExpire
                        page:(NSUInteger)page
                   byAccount:(NSString *)accountID {
    if([NSUserDefaults getCurrentUserID] && [NSUserDefaults getCurrentUserSession]) {
        [self addUserIDAndSessionParams];
    }
    
    self.params[@"M"] = @"Activities.Get";
    
    self.params[@"Channel_Ids"] = [WTRequest generateActivityShowTypesParam:showTypesArray];
    
    self.params[@"Sort"] = [WTRequest generateActivityOrderMethodParam:orderMethod
                                                            smartOrder:smartOrder
                                                            showExpire:showExpire];
    
    self.params[@"Expire"] = [NSString stringWithFormat:@"%d", showExpire];
    
    self.params[@"P"] = [NSString stringWithFormat:@"%d", page];
    
    if (accountID)
        self.params[@"Account_Id"] = accountID;
    
    [self addHashParam];
}

- (void)getActivitiesInTypes:(NSArray *)showTypesArray
                 orderMethod:(NSUInteger)orderMethod
                  smartOrder:(BOOL)smartOrder
                  showExpire:(BOOL)showExpire
                        page:(NSUInteger)page {
    [self getActivitiesInTypes:showTypesArray orderMethod:orderMethod smartOrder:smartOrder showExpire:showExpire page:page byAccount:nil];
}

- (void)setActivityScheduled:(BOOL)scheduled activityID:(NSString *)activityID {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = scheduled ? @"Activity.Schedule" : @"Activity.UnSchedule";
    self.params[@"Id"] = activityID;
    [self addHashParam];
}

- (void)activityInvite:(NSString *)activityID
          inviteUserIDArray:(NSArray *)inviteUserIDArray {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Activity.Invite";
    if (activityID)
        self.params[@"Id"] = activityID;
    self.params[@"UIDs"] = [WTRequest generateUserIDArrayString:inviteUserIDArray];
    [self addHashParam];

}

- (void)acceptActivityInvitation:(NSString *)invitationID {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Activity.Invite.Accept";
    if (invitationID)
        self.params[@"Id"] = invitationID;
    [self addHashParam];
}

- (void)ignoreActivityInvitation:(NSString *)invitationID {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Activity.Invite.Reject";
    if (invitationID)
        self.params[@"Id"] = invitationID;
    [self addHashParam];
}

#pragma Course API

- (void)setCourseScheduled:(BOOL)scheduled
                  courseID:(NSString *)courseID {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = scheduled ? @"Course.Schedule" : @"Course.UnSchedule";
    self.params[@"UNO"] = courseID;
    [self addHashParam];
}

- (void)courseInvite:(NSString *)courseID
   inviteUserIDArray:(NSArray *)inviteUserIDArray {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Course.Invite";
    if (courseID)
        self.params[@"UNO"] = courseID;
    self.params[@"UIDs"] = [WTRequest generateUserIDArrayString:inviteUserIDArray];;
    [self addHashParam];
}

- (void)acceptCourseInvitation:(NSString *)invitationID {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Course.Invite.Accept";
    if (invitationID)
        self.params[@"Id"] = invitationID;
    [self addHashParam];
}

- (void)ignoreCourseInvitation:(NSString *)invitationID {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Course.Invite.Reject";
    if (invitationID)
        self.params[@"Id"] = invitationID;
    [self addHashParam];
}

- (void)getCoursesRegisteredByUser:(NSString *)userID
                         beginDate:(NSDate *)begin
                           endDate:(NSDate *)end {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Courses.Get.ByUser";
    if (userID)
        self.params[@"UID"] = userID;
    self.params[@"Begin"] = [NSString standardDateStringCovertFromDate:begin];
    self.params[@"End"] = [NSString standardDateStringCovertFromDate:end];
    [self addHashParam];
}

#pragma Information API

+ (NSString *)generateInformationShowTypesParam:(NSArray *)showTypesArray {
    if (!showTypesArray)
        return [NSString stringWithFormat:@"1,2,3,4"];
    
    NSMutableString *showTypesString = [NSMutableString string];
    for (int i = 0; i < showTypesArray.count; i++) {
        NSNumber *showTypeNumber = showTypesArray[i];
        if (showTypeNumber.boolValue) {
            [showTypesString appendFormat:@"%@%d", ([showTypesString isEqualToString:@""] ? @"" : @","), i + 1];
        }
    }
    return showTypesString;
}

#define GetInformationSortMethodLikeAsc     @"`like` ASC"
#define GetInformationSortMethodPublishAsc  @"`created_at` ASC"
#define GetInformationSortMethodLikeDesc    @"`like` DESC"
#define GetInformationSortMethodPublishDesc @"`created_at` DESC"

typedef enum {
    InformationOrderByPublishDate  = 1 << 0,
    InformationOrderByPopularity   = 1 << 1,
} InformationOrderMethod;

+ (BOOL)shouldInformationOrderByDesc:(NSUInteger)orderMethod
                          smartOrder:(BOOL)smartOrder {
    BOOL result = NO;
    switch (orderMethod) {
        case InformationOrderByPublishDate:
        {
            result = smartOrder;
        }
            break;
        case InformationOrderByPopularity:
        {
            result = smartOrder;
        }
            break;
        default:
            break;
    }
    return result;
}

+ (NSString *)generateInformationOrderMethodParam:(NSUInteger)orderMethod
                                       smartOrder:(BOOL)smartOrder {
    NSString *result = nil;
    BOOL shouldOrderByDesc = [WTRequest shouldInformationOrderByDesc:orderMethod smartOrder:smartOrder];
    switch (orderMethod) {
        case InformationOrderByPublishDate:
        {
            result = shouldOrderByDesc ? GetInformationSortMethodPublishDesc : GetInformationSortMethodPublishAsc;
        }
            break;
        case InformationOrderByPopularity:
        {
            result = shouldOrderByDesc ? GetInformationSortMethodLikeDesc : GetInformationSortMethodLikeAsc;
        }
            break;
        default:
            break;
    }
    return result;
}

- (void)getInformationInTypes:(NSArray *)showTypesArray
                  orderMethod:(NSUInteger)orderMethod
                   smartOrder:(BOOL)smartOrder
                         page:(NSUInteger)page
                    byAccount:(NSString *)accountID {
    if([NSUserDefaults getCurrentUserID] && [NSUserDefaults getCurrentUserSession]) {
        [self addUserIDAndSessionParams];
    }
    
    self.params[@"M"] = @"Information.GetList";
    
    self.params[@"Category_Ids"] = [WTRequest generateInformationShowTypesParam:showTypesArray];
    
    self.params[@"Sort"] = [WTRequest generateInformationOrderMethodParam:orderMethod smartOrder:smartOrder];
    
    self.params[@"P"] = [NSString stringWithFormat:@"%d", page];
    
    if (accountID)
        self.params[@"Account_Id"] = accountID;
    
    [self addHashParam];
}

- (void)getInformationInTypes:(NSArray *)showTypesArray
                  orderMethod:(NSUInteger)orderMethod
                   smartOrder:(BOOL)smartOrder
                         page:(NSUInteger)page {
    [self getInformationInTypes:showTypesArray orderMethod:orderMethod smartOrder:smartOrder page:page byAccount:nil];
}

- (void)setInformationLiked:(BOOL)liked
              informationID:(NSString *)informationID {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = liked ? @"Information.Like" : @"Information.UnLike";
    self.params[@"Id"] = informationID;
    [self addHashParam];
}

- (void)setInformationFavored:(BOOL)liked
                informationID:(NSString *)informationID {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = liked ? @"Information.Favorite" : @"Information.UnFavorite";
    self.params[@"Id"] = informationID;
    [self addHashParam];
}

#pragma Vision API

- (void)getNewVersion {
    self.params[@"M"] = @"System.Version";
    [self addHashParam];
}

#pragma Star API

- (void)getLatestStar {
    self.params[@"M"] = @"Person.GetLatest";
    [self addHashParam];
}

- (void)getStarsInPage:(NSInteger)page {
    self.params[@"M"] = @"People.Get";
    self.params[@"P"] = [NSString stringWithFormat:@"%d", page];
    [self addHashParam];
}

#pragma Search API

- (void)getSearchResultInCategory:(NSInteger)category
                       keyword:(NSString *)keyword {
    if([NSUserDefaults getCurrentUserID] && [NSUserDefaults getCurrentUserSession]) {
        [self addUserIDAndSessionParams];
    }
    self.params[@"M"] = @"Search";
    self.params[@"Keywords"] = keyword;
    if (category != 0)
        self.params[@"Type"] = [NSString stringWithFormat:@"%d", category];
    [self addHashParam];
}

#pragma Friend API 

- (void)inviteFriends:(NSArray *)userIDArray {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Friend.Invite";
    self.params[@"UIDs"] = [WTRequest generateUserIDArrayString:userIDArray];
    [self addHashParam];
}

- (void)removeFriend:(NSString *)userID {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Friend.Remove";
    if (userID)
        self.params[@"UID"] = userID;
    [self addHashParam];
}

- (void)getFriendsList {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Friends.Get";
    [self addHashParam];
}

- (void)acceptFriendInvitation:(NSString *)invitationID {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Friend.Invite.Accept";
    if (invitationID)
        self.params[@"Id"] = invitationID;
    [self addHashParam];
}

- (void)ignoreFriendInvitation:(NSString *)invitationID {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Friend.Invite.Reject";
    if (invitationID)
        self.params[@"Id"] = invitationID;
    [self addHashParam];
}

- (void)getFriendsWithSameCourse:(NSString *)courseID {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Friends.Get.WithSameCourse";
    if (courseID)
        self.params[@"UNO"] = courseID;
    [self addHashParam];
}

- (void)getFriendsWithSameActivity:(NSString *)activityID {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Friends.Get.WithSameActivity";
    if (activityID)
        self.params[@"Id"] = activityID;
    [self addHashParam];
}

- (void)getFriendsOfUser:(NSString *)userID {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Friends.Get.ByUser";
    if (userID)
        self.params[@"UID"] = userID;
    [self addHashParam];
}

#pragma Notification API

- (void)getNotificationsInPage:(NSInteger)page {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Notifications.Get";
    self.params[@"P"] = [NSString stringWithFormat:@"%d", page];
    self.params[@"OnlyNew"] = @"0";
    [self addHashParam];
}

- (void)getUnreadNotifications {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Notifications.Get";
    self.params[@"OnlyNew"] = @"1";
    [self addHashParam];
}

#pragma Billboard API

- (void)getBillboardPostsInPage:(NSUInteger)page {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Billboard.Get";
    self.params[@"P"] = [NSString stringWithFormat:@"%d", page];
    [self addHashParam];
}

- (void)addBillboardPostWithTitle:(NSString *)title
                          content:(NSString *)content
                            image:(UIImage *)image {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Billboard.Story.Add";
    self.params[@"Title"] = title;
    if (content)
        self.params[@"Body"] = content;
    
    if (image)
        self.uploadImage = image;
    
    self.HTTPMethod = HttpMethodUpLoadImage;
    [self addHashParam];
}

#pragma mark Home API

- (void)getHomeRecommendation {
    if([NSUserDefaults getCurrentUserID] && [NSUserDefaults getCurrentUserSession]) {
        [self addUserIDAndSessionParams];
    }
    self.params[@"M"] = @"Home";
    [self addHashParam];
}

#pragma mark Like API

- (void)setObjectliked:(BOOL)like
                 model:(WTSDKModelType)modelType
               modelID:(NSString *)modelID {
    [self addUserIDAndSessionParams];
    if (like) {
        self.params[@"M"] = @"Like.Add";
    } else {
        self.params[@"M"] = @"Like.Remove";
    }
    self.params[@"Id"] = modelID;
    self.params[@"Model"] = [WTRequest convertModelTypeStringFromModelType:modelType];
    [self addHashParam];
}

- (void)getLikedObjectsListWithModel:(WTSDKModelType)modelType
                                page:(NSInteger)page {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Like.List";
    self.params[@"P"] = [NSString stringWithFormat:@"%d", page];
    self.params[@"Model"] = [WTRequest convertModelTypeStringFromModelType:modelType];
    [self addHashParam];

}

#pragma mark Comment API

- (void)getCommentsForModel:(WTSDKModelType)modelType
                    modelID:(NSString *)modelID
                       page:(NSInteger)page {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Comments.Get";
    self.params[@"Id"] = modelID;
    self.params[@"Model"] = [WTRequest convertModelTypeStringFromModelType:modelType];
    self.params[@"P"] = [NSString stringWithFormat:@"%d", page];
    [self addHashParam];
}

- (void)commentModel:(WTSDKModelType)modelType
             modelID:(NSString *)modelID
         commentBody:(NSString *)commentBody {
    [self addUserIDAndSessionParams];
    self.params[@"M"] = @"Comment.Add";
    self.params[@"Id"] = modelID;
    self.params[@"Model"] = [WTRequest convertModelTypeStringFromModelType:modelType];
    if (commentBody)
        self.params[@"Body"] = commentBody;
    [self addHashParam];
}

#pragma mark Account API 

- (void)getAccount:(NSString *)accountID {
    self.params[@"M"] = @"Account.Get";
    self.params[@"Id"] = accountID;
    [self addHashParam];
}

@end
