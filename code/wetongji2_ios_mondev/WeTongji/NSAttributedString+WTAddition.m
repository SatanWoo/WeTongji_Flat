//
//  NSAttributedString+WTAddition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-25.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "NSAttributedString+WTAddition.h"
#import "NSAttributedString+Attributes.h"

@implementation NSAttributedString (WTAddition)

+ (NSAttributedString *)friendCountStringConvertFromCountNumber:(NSNumber *)countNumber
                                                           font:(UIFont *)font
                                                      textColor:(UIColor *)color {
    NSString *friendString = countNumber.integerValue > 1 ? @"Friends" : @"Friend";
    NSString *countString = [NSString stringWithFormat:@"%d", countNumber.integerValue];
    NSString *resultString = [NSString stringWithFormat:@"%@ %@", countString, NSLocalizedString(friendString, nil)];
    
    NSMutableAttributedString *resultAttribuedString = [[NSMutableAttributedString alloc] initWithString:resultString];
    [resultAttribuedString setTextAlignment:kCTTextAlignmentRight lineBreakMode:kCTLineBreakByCharWrapping];
    [resultAttribuedString setTextColor:color];
    [resultAttribuedString setFont:font];
    [resultAttribuedString setTextBold:YES range:NSMakeRange(0, countString.length)];
    
    return resultAttribuedString;
}

+ (NSAttributedString *)commentCountStringConvertFromCountNumber:(NSNumber *)countNumber
                                                            font:(UIFont *)font
                                                       textColor:(UIColor *)color {
    NSString *friendString = countNumber.integerValue > 1 ? @"Comments" : @"Comment";
    NSString *countString = [NSString stringWithFormat:@"%d", countNumber.integerValue];
    NSString *resultString = [NSString stringWithFormat:@"%@ %@", countString, NSLocalizedString(friendString, nil)];
    
    NSMutableAttributedString *resultAttribuedString = [[NSMutableAttributedString alloc] initWithString:resultString];
    [resultAttribuedString setTextBold:YES range:NSMakeRange(0, countString.length)];
    [resultAttribuedString setTextColor:color];
    [resultAttribuedString setFont:font];
    
    return resultAttribuedString;
}

+ (NSAttributedString *)searchHintStringForKeyword:(NSString *)keyword
                                          category:(NSString *)category
                                        attributes:(NSDictionary *)attributes {
    NSString *hintString = nil;
    NSMutableAttributedString *result = nil;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"zh-Hans"]) {
        hintString = [NSString stringWithFormat:@"搜索关于“%@”的%@", keyword, category];
        result = [NSMutableAttributedString attributedStringWithString:hintString];
        [result setAttributes:attributes range:NSMakeRange(0, result.length)];
        [result setTextBold:YES range:NSMakeRange(5, keyword.length)];
    } else if ([language isEqualToString:@"de"]) {
        hintString = [NSString stringWithFormat:@"Suchen %@ nach %@", category, keyword];
        result = [NSMutableAttributedString attributedStringWithString:hintString];
        [result setAttributes:attributes range:NSMakeRange(0, result.length)];
        [result setTextBold:YES range:NSMakeRange(hintString.length - keyword.length, keyword.length)];
    } else {
        hintString = [NSString stringWithFormat:@"Search %@ for %@", category, keyword];
        result = [NSMutableAttributedString attributedStringWithString:hintString];
        [result setAttributes:attributes range:NSMakeRange(0, result.length)];
        [result setTextBold:YES range:NSMakeRange(hintString.length - keyword.length, keyword.length)];
    }
    return result;
}

@end
