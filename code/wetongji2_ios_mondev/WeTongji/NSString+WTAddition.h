//
//  NSString+WTAddition.h
//  WeTongji
//
//  Created by 紫川 王 on 12-4-26.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NSDate+WTAddition.h"

@interface NSString (WTAddition)

- (NSDate *)convertToDate;

+ (NSString *)yearMonthDayWeekTimeStringConvertFromBeginDate:(NSDate *)begin
                                                     endDate:(NSDate *)end;
+ (NSString *)timeStringConvertFromBeginDate:(NSDate *)begin
                                     endDate:(NSDate *)end;
+ (NSString *)weekStringConvertFromInteger:(NSInteger)week;

- (BOOL)isSuitableForPassword;
- (BOOL)isGIFURL;
- (BOOL)isEmptyImageURL;
- (NSString *)clearAllBacklashR;

+ (NSString *)friendCountStringConvertFromCountNumber:(NSNumber *)countNumber;
+ (NSString *)commentCountStringConvertFromCountNumber:(NSNumber *)countNumber;
+ (NSString *)searchCategoryStringForCategory:(NSInteger)category;
+ (NSString *)inviteStringConvertFromCount:(NSInteger)count;
+ (NSString *)deleteFriendStringForFriendName:(NSString *)name;
+ (NSString *)volumeStringForVolumeNumber:(NSNumber *)volume;
- (UIColor *)converHexStringToColorWithAlpha:(CGFloat)alpha;

@end
