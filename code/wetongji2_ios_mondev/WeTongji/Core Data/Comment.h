//
//  Comment.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object.h"

@class CommentableObject, User;

@interface Comment : Object

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) User *author;
@property (nonatomic, retain) CommentableObject *owner;

@end
