//
//  Object.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Controller;

@interface Object : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * objectClass;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *belongToControllers;
@end

@interface Object (CoreDataGeneratedAccessors)

- (void)addBelongToControllersObject:(Controller *)value;
- (void)removeBelongToControllersObject:(Controller *)value;
- (void)addBelongToControllers:(NSSet *)values;
- (void)removeBelongToControllers:(NSSet *)values;

@end
