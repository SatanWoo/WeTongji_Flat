//
//  BillboardPost.h
//  WeTongji
//
//  Created by 王 紫川 on 13-6-1.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommentableObject.h"

@class User;

@interface BillboardPost : CommentableObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) User *author;

@end
