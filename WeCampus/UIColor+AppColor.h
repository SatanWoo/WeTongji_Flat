//
//  UIColor+AppColor.h
//  TextCrop
//
//  Created by song on 13-8-14.
//  Copyright (c) 2013年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(r, g, b) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r, g, b, a) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface UIColor (AppColor)

+ (UIColor*)appNowWeekListDateUnselectColor;
+ (UIColor*)appNowWeekListDateSelectColor;
+ (UIColor*)appNowWeekListDateTodayColor;

+ (UIColor*)appNowCourseEventStartTimeLabelColor;
+ (UIColor*)appNowActivityEventStartTimeLabelColor;
+ (UIColor*)appNowEventPastStartTimeLabelColor;

@end
