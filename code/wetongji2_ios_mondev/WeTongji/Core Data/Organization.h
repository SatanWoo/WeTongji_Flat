//
//  Organization.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-23.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LikeableObject.h"

@class Activity, News;

@interface Organization : LikeableObject

@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSNumber * activityCount;
@property (nonatomic, retain) NSString * administrator;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * bgImage;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * newsCount;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * adminTitle;
@property (nonatomic, retain) NSSet *publishedActivities;
@property (nonatomic, retain) NSSet *publishedNews;
@end

@interface Organization (CoreDataGeneratedAccessors)

- (void)addPublishedActivitiesObject:(Activity *)value;
- (void)removePublishedActivitiesObject:(Activity *)value;
- (void)addPublishedActivities:(NSSet *)values;
- (void)removePublishedActivities:(NSSet *)values;

- (void)addPublishedNewsObject:(News *)value;
- (void)removePublishedNewsObject:(News *)value;
- (void)addPublishedNews:(NSSet *)values;
- (void)removePublishedNews:(NSSet *)values;

@end
