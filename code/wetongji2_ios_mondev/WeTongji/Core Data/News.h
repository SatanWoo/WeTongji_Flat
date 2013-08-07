//
//  News.h
//  WeTongji
//
//  Created by 王 紫川 on 13-6-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommentableObject.h"

@class Organization;

@interface News : CommentableObject

@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * hasTicket;
@property (nonatomic, retain) id imageArray;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSDate * publishDate;
@property (nonatomic, retain) NSString * publishDay;
@property (nonatomic, retain) NSNumber * readCount;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * ticketInfo;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Organization *author;

@end
