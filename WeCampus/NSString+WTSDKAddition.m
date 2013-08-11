//
//  NSString+WTSDKAddition.m
//  WeTongji
//
//  Created by 紫川 王 on 12-4-26.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NSString+WTSDKAddition.h"

@implementation NSString (WTSDKAddition)

+ (NSString *)standardDateStringCovertFromDate:(NSDate *)date {
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"];
    NSMutableString *result = [NSMutableString stringWithString:[form stringFromDate:date]];
    [result insertString:@":" atIndex:result.length - 2];
    NSLog(@"standard:%@", result);
    return result;
}


@end
