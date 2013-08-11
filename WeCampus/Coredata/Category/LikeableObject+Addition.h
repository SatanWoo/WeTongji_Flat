//
//  LikeableObject+Addition.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "LikeableObject.h"

@interface LikeableObject (Addition)

@property (nonatomic) BOOL likedByCurrentUser;

- (void)configureLikeInfo:(NSDictionary *)dict;

@end
