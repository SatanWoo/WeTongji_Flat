//
//  NSString+LanguageDetect.m
//  TextCrop
//
//  Created by song on 13-8-14.
//  Copyright (c) 2013年 song. All rights reserved.
//

#import "NSString+NaturlLanguage.h"

@implementation NSString (NaturlLanguage)
+ (NSString *)languageForString:(NSString *) text
{
    return (NSString *)CFBridgingRelease(CFStringTokenizerCopyBestStringLanguage((CFStringRef)text, CFRangeMake(0, MIN(text.length,400))));
}

+ (NSString*)transformToLatin:(NSString*) text
{
    NSMutableString *buffer = [NSMutableString stringWithString:text];
    CFMutableStringRef bufferRef = (__bridge CFMutableStringRef)buffer;
    CFStringTransform(bufferRef, NULL, kCFStringTransformToLatin, false);
    return buffer;
}


+ (NSString*)removeAccent:(NSString*) text
{
    NSMutableString *buffer = [NSMutableString stringWithString:text];
    CFMutableStringRef bufferRef = (__bridge CFMutableStringRef)buffer;
    CFStringTransform(bufferRef, NULL, kCFStringTransformStripCombiningMarks, false);
    return buffer;
}
@end
