//
//  NSString+LanguageDetect.h
//  TextCrop
//
//  Created by song on 13-8-14.
//  Copyright (c) 2013年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NaturlLanguage)

+ (NSString *)languageForString:(NSString *) text;
+ (NSString*)transformToLatin:(NSString*) text;
+ (NSString*)removeAccent:(NSString*) text;

@end
