//
//  WTRequest.h
//  WeTongjiSDK
//
//  Created by 王 紫川 on 13-3-8.
//  Copyright (c) 2013年 WeTongji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WTCommon.h"
#import "AFHTTPRequestOperation.h"
#import "NSUserDefaults+WTSDKAddition.h"

#define GetActivitySortMethodLikeDesc   @"`like` DESC"
#define GetActivitySortMethodBeginDesc  @"`begin` DESC"
#define GetActivitySortMethodCreateDesc @"`created_at` DESC"

#define GetInformationTypeSchoolNews    @"SchoolNews"
#define GetInformationTypeClubNews      @"ClubNews"
#define GetInformationTypeAround        @"Around"
#define GetInformationTypeForStaff      @"ForStaff"

#define HttpMethodGET           @"GET"
#define HttpMethodPOST          @"POST"
#define HttpMethodUpLoadImage   @"UPLOAD_IMAGE"

typedef enum {
    WTSDKBillboard,
    WTSDKActivity,
    WTSDKInformation,
    WTSDKStar,
    WTSDKOrganization,
    WTSDKUser,
    WTSDKCourse,
} WTSDKModelType;   

@interface WTRequest : NSObject

@property (nonatomic, copy,     readonly) WTSuccessCompletionBlock successCompletionBlock;
@property (nonatomic, copy,     readonly) WTFailureCompletionBlock failureCompletionBlock;
@property (nonatomic, copy,     readonly) WTSuccessCompletionBlock preSuccessCompletionBlock;
@property (nonatomic, copy,     readonly) NSString *HTTPMethod;
@property (nonatomic, strong,   readonly) NSMutableDictionary *params;
@property (nonatomic, strong,   readonly) NSMutableDictionary *postValue;
@property (nonatomic, strong,   readonly) UIImage *uploadImage;
@property (nonatomic, copy,     readonly) NSString *queryString;
@property (nonatomic, assign,   readonly, getter = isValid) BOOL valid;
@property (nonatomic, strong,   readonly) NSError *error;

+ (WTRequest *)requestWithSuccessBlock:(WTSuccessCompletionBlock)success
                          failureBlock:(WTFailureCompletionBlock)failure;

#pragma mark - User API

- (void)loginWithStudentNumber:(NSString *)studentNumber
                      password:(NSString *)password;

- (void)activateUserWithStudentNumber:(NSString *)studentNumber
                             password:(NSString *)password
                                 name:(NSString *)name;

- (void)updateUserEmail:(NSString *)email
              weiboName:(NSString *)weibo
               phoneNum:(NSString *)phone
              qqAccount:(NSString *)qq
                  motto:(NSString *)motto
                   dorm:(NSString *)dorm;

- (void)updatePassword:(NSString *)newPassword
           oldPassword:(NSString *)oldPassword;

- (void)updateUserAvatar:(UIImage *)image;

- (void)getUserInformation;

- (void)resetPasswordWithStudentNumber:(NSString *)studentNumber
                                  name:(NSString*)name;

#pragma mark - Schedule API

- (void)getScheduleWithBeginDate:(NSDate *)begin
                         endDate:(NSDate *)end;

- (void)getScheduleSetting;

#pragma mark - Activity API

+ (BOOL)shouldActivityOrderByDesc:(NSUInteger)orderMethod
                       smartOrder:(BOOL)smartOrder
                       showExpire:(BOOL)showExpire;

- (void)getActivitiesInTypes:(NSArray *)showTypesArray
                 orderMethod:(NSUInteger)orderMethod
                  smartOrder:(BOOL)smartOrder
                  showExpire:(BOOL)showExpire
                        page:(NSUInteger)page;

- (void)getActivitiesInTypes:(NSArray *)showTypesArray
                 orderMethod:(NSUInteger)orderMethod
                  smartOrder:(BOOL)smartOrder
                  showExpire:(BOOL)showExpire
                        page:(NSUInteger)page
                   byAccount:(NSString *)accountID;

- (void)getActivitiesInTypes:(NSArray *)showTypesArray
                 orderMethod:(NSUInteger)orderMethod
                  smartOrder:(BOOL)smartOrder
                  showExpire:(BOOL)showExpire
                        page:(NSUInteger)page
             scheduledByUser:(NSString *)userID;

- (void)setActivityScheduled:(BOOL)scheduled
                  activityID:(NSString *)activityID;

- (void)activityInvite:(NSString *)activityID
          inviteUserIDArray:(NSArray *)inviteUserIDArray;

- (void)acceptActivityInvitation:(NSString *)invitationID;

- (void)ignoreActivityInvitation:(NSString *)invitationID;


#pragma - Course API

- (void)setCourseScheduled:(BOOL)scheduled
                  courseID:(NSString *)courseID;

- (void)courseInvite:(NSString *)courseID
   inviteUserIDArray:(NSArray *)inviteUserIDArray;

- (void)acceptCourseInvitation:(NSString *)invitationID;

- (void)ignoreCourseInvitation:(NSString *)invitationID;

- (void)getCoursesRegisteredByUser:(NSString *)userID
                         beginDate:(NSDate *)begin
                           endDate:(NSDate *)end;

#pragma - Information API

+ (BOOL)shouldInformationOrderByDesc:(NSUInteger)orderMethod
                          smartOrder:(BOOL)smartOrder;

- (void)getInformationInTypes:(NSArray *)showTypesArray
                  orderMethod:(NSUInteger)orderMethod
                   smartOrder:(BOOL)smartOrder
                         page:(NSUInteger)page;

- (void)getInformationInTypes:(NSArray *)showTypesArray
                  orderMethod:(NSUInteger)orderMethod
                   smartOrder:(BOOL)smartOrder
                         page:(NSUInteger)page
                    byAccount:(NSString *)accountID;

- (void)setInformationLiked:(BOOL)liked
              informationID:(NSString *)informationID;

- (void)setInformationFavored:(BOOL)liked
                informationID:(NSString *)informationID;

#pragma mark - Vision API

- (void)getNewVersion;

#pragma - Star API

- (void)getLatestStar;

- (void)getStarsInPage:(NSInteger)page;

#pragma - Search API

- (void)getSearchResultInCategory:(NSInteger)category
                          keyword:(NSString *)keyword;

#pragma - Friend API

- (void)inviteFriends:(NSArray *)userIDArray;

- (void)removeFriend:(NSString *)userID;

- (void)getFriendsList;

- (void)acceptFriendInvitation:(NSString *)invitationID;

- (void)ignoreFriendInvitation:(NSString *)invitationID;

- (void)getFriendsWithSameCourse:(NSString *)courseID;

- (void)getFriendsWithSameActivity:(NSString *)activityID;

- (void)getFriendsOfUser:(NSString *)userID;

#pragma - Notification API

- (void)getNotificationsInPage:(NSInteger)page;

- (void)getUnreadNotifications;

#pragma - Billboard API

- (void)getBillboardPostsInPage:(NSUInteger)page;

- (void)addBillboardPostWithTitle:(NSString *)title
                          content:(NSString *)content
                            image:(UIImage *)image;

#pragma - Like API

- (void)setObjectliked:(BOOL)like
                 model:(WTSDKModelType)modelType
               modelID:(NSString *)modelID;

- (void)getLikedObjectsListWithModel:(WTSDKModelType)modelType
                                page:(NSInteger)page;

#pragma - Comment API

- (void)getCommentsForModel:(WTSDKModelType)modelType
                    modelID:(NSString *)modelID
                       page:(NSInteger)page;

- (void)commentModel:(WTSDKModelType)modelType
             modelID:(NSString *)modelID
         commentBody:(NSString *)commentBody;

#pragma - Home API

- (void)getHomeRecommendation;

#pragma - Account API

- (void)getAccount:(NSString *)accountID;

@end