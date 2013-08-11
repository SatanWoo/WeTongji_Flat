//
//  Star+Addition.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-7.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Star.h"

@interface Star (Addition)

@property (nonatomic, readonly) NSArray *imageURLStringArray;
@property (nonatomic, readonly) NSArray *imageDescriptionArray;

+ (Star *)insertStar:(NSDictionary *)dict;

+ (Star *)starWithID:(NSString *)starID;

@end
