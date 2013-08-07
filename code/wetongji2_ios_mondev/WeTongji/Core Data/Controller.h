//
//  Controller.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Object;

@interface Controller : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSSet *hasObjects;
@end

@interface Controller (CoreDataGeneratedAccessors)

- (void)addHasObjectsObject:(Object *)value;
- (void)removeHasObjectsObject:(Object *)value;
- (void)addHasObjects:(NSSet *)values;
- (void)removeHasObjects:(NSSet *)values;

@end
