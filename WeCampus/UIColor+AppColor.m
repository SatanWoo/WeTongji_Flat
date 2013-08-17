//
//  UIColor+AppColor.m
//  TextCrop
//
//  Created by song on 13-8-14.
//  Copyright (c) 2013年 song. All rights reserved.
//

#import "UIColor+AppColor.h"
#import "UIColor+Hex.h"

@implementation UIColor (AppColor)

+ (UIColor*)appNowWeekListDateUnselectColor
{
    return [UIColor lightGrayColor];
}

+ (UIColor*)appNowWeekListDateSelectColor
{
    return [UIColor darkGrayColor];
}

+ (UIColor*)appNowWeekListDateTodayColor
{
    return RGB(233, 71, 59);
}




+ (UIColor*)appNowCourseEventStartTimeLabelColor
{
    return [UIColor colorWithHex:0xf2c81e];
}

+ (UIColor*)appNowActivityEventStartTimeLabelColor
{
    return [UIColor colorWithHex:0x2cc1a5];
}
+ (UIColor*)appNowEventPastStartTimeLabelColor
{
    return [UIColor lightGrayColor];
}
@end
