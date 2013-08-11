//
//  CommentableObject.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LikeableObject.h"

@class Comment;

@interface CommentableObject : LikeableObject

@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSSet *comments;
@end

@interface CommentableObject (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
