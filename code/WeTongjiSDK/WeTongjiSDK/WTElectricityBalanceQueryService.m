//
//  WTElectricityBalanceQueryService.m
//  WeTongjiSDK
//
//  Created by 王 紫川 on 12-11-30.
//  Copyright (c) 2012年 WeTongji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTElectricityBalanceQueryService.h"
#import "TFHpple.h"

#define BASE_URL_STRING @"http://nyglzx.tongji.edu.cn/web/datastat.aspx"

#define kDistrictIndexArray @"DistrictIndexArray"

#define DistrictBuildingIndexInvalid (-1)

typedef enum {
    WTElectricityBalanceQueryProcessStateLoading,
    WTElectricityBalanceQueryProcessStateSelectingDistrict,
    WTElectricityBalanceQueryProcessStateQuerying,
} WTElectricityBalanceQueryProcessState;

@interface WTElectricityBalanceQueryService() <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSDictionary *districtBuildingMap;
@property (nonatomic, assign) WTElectricityBalanceQueryProcessState processState;

@property (nonatomic, copy) WTSuccessCompletionBlock successCompletionBlock;
@property (nonatomic, copy) WTFailureCompletionBlock failureCompletionBlock;

@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *building;
@property (nonatomic, copy) NSString *room;

@property (nonatomic, assign) NSUInteger districtIndex;
@property (nonatomic, assign) NSUInteger buildingIndex;

@property (nonatomic, assign) BOOL isBusy;

@end

@implementation WTElectricityBalanceQueryService

#pragma mark - Life cycle

+ (WTElectricityBalanceQueryService *)sharedService
{
    static WTElectricityBalanceQueryService *instance = nil;
    static dispatch_once_t WTElectricityBalanceQueryServicePredicate;
    dispatch_once(&WTElectricityBalanceQueryServicePredicate, ^{
        instance = [[WTElectricityBalanceQueryService alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self loadDistrictBuildingMap];
    }
    return self;
}

#pragma mark - Properties

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
    }
    return _webView;
}

#pragma mark - Logic methods

- (void)loadDistrictBuildingMap {
    NSString *configFilePath = [[NSBundle mainBundle] pathForResource:@"WTDistrictBuildingMap" ofType:@"plist"];
    self.districtBuildingMap = [[NSDictionary alloc] initWithContentsOfFile:configFilePath];
}

- (void)configDistrictBuildingIndex {
    self.districtIndex = DistrictBuildingIndexInvalid;
    self.buildingIndex = DistrictBuildingIndexInvalid;
    
    NSArray *districtIndexArray = self.districtBuildingMap[kDistrictIndexArray];
    [districtIndexArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([self.district isEqualToString:obj]) {
            self.districtIndex = idx + 1;
            *stop = YES;
        }
    }];
    
    NSArray *buildingIndexArray = self.districtBuildingMap[self.district];
    [buildingIndexArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([self.building isEqualToString:obj]) {
            self.buildingIndex = idx;
            *stop = YES;
        }
    }];
}

- (NSArray *)parserBalanceWithHTMLData:(NSData *)HTMLData {
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"yyyy-MM-dd"];
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:HTMLData];
    NSArray *elements = [xpathParser searchWithXPathQuery:@"//td"];
    
    // Try to find today's element.
    __block NSUInteger todayElementIndex = -1;
    for(int i = 0; i < 3; i++) {
        NSString *todayDateString = [form stringFromDate:[[NSDate date] dateByAddingTimeInterval:-60 * 60 * 24 * i]];
        [elements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TFHppleElement *element = obj;
            if ([todayDateString isEqualToString:element.text]) {
                todayElementIndex = idx;
                *stop = YES;
            }
        }];
        if (todayElementIndex != -1) {
            break;
        }
    }
    
    // Still can't find, return nil.
    if (todayElementIndex == -1)
        return nil;
    
    NSUInteger beginBalanceElementIndex = todayElementIndex + 3;
    NSUInteger endBalanceElementIndex = beginBalanceElementIndex + 4 * 9;
    if (elements.count > beginBalanceElementIndex) {
        TFHppleElement *todayBalanceElement = elements[beginBalanceElementIndex];
        NSString *todayBalance = [NSString stringWithFormat:@"%@", todayBalanceElement.text];
        float todayBalanceValue = todayBalance.floatValue;
        NSMutableArray *result = [NSMutableArray arrayWithObject:@(todayBalanceValue)];
        
        if (elements.count > endBalanceElementIndex) {
            float avarageUse = 0;
            for(NSInteger i = 0; i < 9; i++) {
                NSInteger elementIndex = beginBalanceElementIndex + i * 4;
                TFHppleElement *balanceElement = elements[elementIndex];
                float elementValue = [balanceElement.text floatValue];
                
                TFHppleElement *formerBalanceElement = elements[elementIndex + 4];
                float formerElementValue = [formerBalanceElement.text floatValue];
                
                if (elementValue > formerElementValue) {
                    avarageUse = (i == 0) ? 0 : (elementValue - todayBalanceValue) / i;
                    break;
                }
                
                if (i == 8) {
                    avarageUse = (formerElementValue - todayBalanceValue) / 9;
                }
            }
            [result addObject:@(avarageUse)];
        }
        
        return result;
    }    
    return nil;
}


#pragma mark - Public methods

- (void)getElectricChargeBalanceWithDistrict:(NSString *)district
                                    building:(NSString *)building
                                        room:(NSString *)room
                                successBlock:(WTSuccessCompletionBlock)success
                                failureBlock:(WTFailureCompletionBlock)failure {
    if (self.isBusy)
        return;
    
    if (!(district && building && room))
        return;
    
    self.district = district;
    self.building = building;
    self.room = room;
    
    [self configDistrictBuildingIndex];
    
    if (self.districtIndex == DistrictBuildingIndexInvalid
       || self.buildingIndex == DistrictBuildingIndexInvalid
       || self.room.length == 0)
        return;
    
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
    
    NSURL *url =[[NSURL alloc] initWithString:BASE_URL_STRING];
    NSURLRequest *request =  [[NSURLRequest alloc] initWithURL:url];
    self.webView = nil;
    [self.webView loadRequest:request];
    
    self.isBusy = YES;
    self.processState = WTElectricityBalanceQueryProcessStateLoading;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    switch (self.processState) {
        case WTElectricityBalanceQueryProcessStateLoading: {
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.form1.DistrictDown.options[%d].selected=true;", self.districtIndex]];
            [self.webView stringByEvaluatingJavaScriptFromString:@"document.form1.DistrictDown.onchange()"];
            self.processState = WTElectricityBalanceQueryProcessStateSelectingDistrict;
            break;
        }
        case WTElectricityBalanceQueryProcessStateSelectingDistrict: {
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.form1.BuildingDown.options[%d].selected=true;", self.buildingIndex]];
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.form1.RoomnameText.value=\"%@\"", self.room]];
            [webView stringByEvaluatingJavaScriptFromString:@"document.form1.Submit.click();"];
            self.processState = WTElectricityBalanceQueryProcessStateQuerying;
            break;
        }
        case WTElectricityBalanceQueryProcessStateQuerying: {
            if (self.successCompletionBlock) {
                NSString *HTMLString = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
                NSString *UTF8String = [HTMLString stringByReplacingOccurrencesOfString:@"gb2312" withString:@"UTF-8"];
                NSLog(@"UTF8 string: %@", UTF8String);
                NSArray *result = [self parserBalanceWithHTMLData:[UTF8String dataUsingEncoding:NSUTF8StringEncoding]];
                if (result == nil) {
                    if (self.failureCompletionBlock) {
                        NSError *error = [[NSError alloc] initWithDomain:@"com.tac.wetongji" code:-1 userInfo:nil];
                        self.failureCompletionBlock(error);
                    }
                } else {
                    if (self.successCompletionBlock) {
                        self.successCompletionBlock(result);
                    }
                }
                self.isBusy = NO;
            }
            break;
        }
        default:
            break;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (self.failureCompletionBlock) {
        self.failureCompletionBlock(error);
    }
    self.isBusy = NO;
}

@end
