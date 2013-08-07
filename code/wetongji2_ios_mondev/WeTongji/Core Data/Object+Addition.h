//
//  Object+Addition.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-5.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Object.h"

@interface Object (Addition)

- (void)setObjectHeldByHolder:(Class)holderClass;

+ (void)setOutdatedObjectsFreeFromHolder:(Class)holderClass;

- (void)setObjectFreeFromHolder:(Class)holderClass;

+ (void)setAllObjectsFreeFromHolder:(Class)holderClass;

+ (NSArray *)getAllObjectsHeldByHolder:(Class)holderClass
                      objectEntityName:(NSString *)entityName;

- (NSInteger)getObjectModelType;

+ (NSInteger)convertObjectClassToModelType:(NSString *)objectClass;

@end
