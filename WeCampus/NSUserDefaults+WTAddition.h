//
//  NSUserDefaults+Addition.h
//  WeTongji
//
//  Created by 王 紫川 on 13-2-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NewsOrderByPublishDate  = 1 << 0,
    NewsOrderByPopularity   = 1 << 1,
} NewsOrderMethod;

typedef enum {
    ActivityOrderByPublishDate  = 1 << 0,
    ActivityOrderByPopularity   = 1 << 1,
    ActivityOrderByStartDate    = 1 << 2,
} ActivityOrderMethod;

typedef enum {
    NewsShowTypeCampusUpdate            = 1 << 0,
    NewsShowTypeClubNews                = 1 << 1,
    NewsShowTypeLocalRecommandation     = 1 << 2,
    NewsShowTypeAdministrativeAffairs   = 1 << 3,
    NewsShowTypeMyCollege               = 1 << 4,
} NewsShowTypes;

#define NewsShowTypesCount      4

typedef enum {
    ActivityShowTypeAcademics       = 1 << 0,
    ActivityShowTypeCompetition     = 1 << 1,
    ActivityShowTypeEntertainment   = 1 << 2,
    ActivityShowTypeEnterprise      = 1 << 3,
} ActivityShowTypes;

#define ActivityShowTypesCount  4

#define NewsShowTypesAll (NewsShowTypeCampusUpdate + NewsShowTypeClubNews + NewsShowTypeLocalRecommandation + NewsShowTypeAdministrativeAffairs)

#define ActivityShowTypesAll (ActivityShowTypeAcademics + ActivityShowTypeEntertainment + ActivityShowTypeEnterprise + ActivityShowTypeCompetition)

@class Event;

@interface NSUserDefaults (WTAddition)

#pragma mark News

+ (NSArray *)getShowAllNewsTypesArray;

// 返回一个数组, 数组中的元素按|NewsShowTypes|排列, 类型均为包含一个BOOL类型数据的NSNumber
+ (NSArray *)getNewsShowTypesArray;

+ (NSSet *)getNewsShowTypesSet;

+ (NSArray *)getNewsShowTypesArrayWithNewsShowType:(NewsShowTypes)type;

- (NewsOrderMethod)getNewsOrderMethod;

- (BOOL)getNewsSmartOrderProperty;

- (BOOL)isNewsSettingDifferentFromDefaultValue;

- (void)setNewsShowTypes:(NewsShowTypes)types;

#pragma mark Activity

+ (NSArray *)getShowAllActivityTypesArray;

// 返回一个数组, 数组中的元素按|ActivityShowTypes|排列, 类型均为包含一个BOOL类型数据的NSNumber
+ (NSArray *)getActivityShowTypesArray;

+ (NSSet *)getActivityShowTypesSet;

+ (NSArray *)getActivityShowTypesArrayWithActivityShowType:(ActivityShowTypes)type;

- (ActivityOrderMethod)getActivityOrderMethod;

- (BOOL)getActivityHidePastProperty;

- (BOOL)getActivitySmartOrderProperty;

- (BOOL)isActivitySettingDifferentFromDefaultValue;

- (void)setActivityShowTypes:(ActivityShowTypes)types;

#pragma mark Search history

+ (NSString *)getSearchHistoryKeyword:(NSDictionary *)dict;

+ (NSInteger)getSearchHistoryCategory:(NSDictionary *)dict;

- (void)addSearchHistoryItemWithSearchKeyword:(NSString *)keyword
                               searchCategory:(NSInteger)category;

- (void)clearAllSearchHistoryItems;

- (NSArray *)getSearchHistoryArray;

#pragma mark Current user info

- (void)setCurrentUserMotto:(NSString *)motto;

- (void)setCurrentUserPhone:(NSString *)phone;

- (void)setCurrentUserEmail:(NSString *)email;

- (void)setCurrentUserSinaWeibo:(NSString *)sinaWeibo;

- (void)setCurrentUserQQ:(NSString *)QQ;

- (void)setCurrentUserDorm:(NSString *)drom;

- (NSString *)getCurrentUserMotto;

- (NSString *)getCurrentUserPhone;

- (NSString *)getCurrentUserEmail;

- (NSString *)getCurrentUserSinaWeibo;

- (NSString *)getCurrentUserQQ;

- (NSString *)getCurrentDorm;

- (NSTimeInterval)getLastHomeUpdateTime;

- (void)setLastHomeUpdateTime:(NSTimeInterval)time;

#pragma mark Semester begin end time info

//- (NSDate *)getCurrentSemesterBeginTime;
//
//- (void)setCurrentSemesterBeginTime:(NSDate *)time;
//
//- (NSInteger)getCurrentSemesterWeekCount;
//
//- (void)setCurrentSemesterWeekCount:(NSInteger)count;

#pragma mark First login

- (BOOL)isFirstLogin;

- (void)setFirstLogin:(BOOL)firstLogin;

#pragma mark - Event notification

- (BOOL)isEventLocalNotificationRegistered:(Event *)event;

- (void)setEvent:(Event *)event localNotificationRegistered:(BOOL)registered;

- (BOOL)scheduleNotificationEnabled;

@end
