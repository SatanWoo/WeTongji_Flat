//
//  User+Addition.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "User.h"

@interface User (Addition)

@property (nonatomic, readonly) NSString *dormString;

+ (User *)insertUser:(NSDictionary *)dict;

+ (User *)userWithID:(NSString *)userID;

@end
