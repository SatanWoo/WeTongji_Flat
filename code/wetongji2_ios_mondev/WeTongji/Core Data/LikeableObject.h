//
//  LikeableObject.h
//  WeTongji
//
//  Created by 王 紫川 on 13-6-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object.h"

@class User;

@interface LikeableObject : Object

@property (nonatomic, retain) NSNumber * likeCount;
@property (nonatomic, retain) NSSet *likedBy;
@end

@interface LikeableObject (CoreDataGeneratedAccessors)

- (void)addLikedByObject:(User *)value;
- (void)removeLikedByObject:(User *)value;
- (void)addLikedBy:(NSSet *)values;
- (void)removeLikedBy:(NSSet *)values;

@end
