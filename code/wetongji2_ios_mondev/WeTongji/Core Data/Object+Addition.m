//
//  Object+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-5.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Object+Addition.h"
#import "WTCoreDataManager.h"
#import "Controller+Addition.h"
#import "BillboardPost.h"
#import "Activity.h"
#import "News.h"
#import "Star.h"
#import "Organization.h"
#import "Course.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

@implementation Object (Addition)

+ (NSArray *)getAllObjectsHeldByHolder:(Class)holderClass
                      objectEntityName:(NSString *)entityName {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES]];
    
    Controller *controller = [Controller controllerModelForClass:holderClass];
    [request setPredicate:[NSPredicate predicateWithFormat:@"SELF in %@", controller.hasObjects]];
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    return result;
}

- (void)setObjectHeldByHolder:(Class)holderClass {
    Controller *controller = [Controller controllerModelForClass:holderClass];
    [controller addHasObjectsObject:self];
}

- (void)setObjectFreeFromHolder:(Class)holderClass {
    Controller *controller = [Controller controllerModelForClass:holderClass];
    [self removeBelongToControllersObject:controller];
    
    if (self.belongToControllers.count == 0) {
        if ([self isKindOfClass:[User class]] || [self isKindOfClass:[Organization class]]) {
            return;
        }
        WTLOG(@"Delete object:%@", NSStringFromClass([self class]));
        NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
        [context deleteObject:self];
    }
}

+ (void)setAllObjectsFreeFromHolder:(Class)holderClass {
    Controller *controller = [Controller controllerModelForClass:holderClass];
    NSSet *hasObjectsSet = [NSSet setWithSet:controller.hasObjects];
    for (Object *object in hasObjectsSet) {
        [object setObjectFreeFromHolder:holderClass];
    }
}

+ (void)setOutdatedObjectsFreeFromHolder:(Class)holderClass {
    Controller *controller = [Controller controllerModelForClass:holderClass];
    NSSet *hasObjectsSet = [NSSet setWithSet:controller.hasObjects];
    for (Object *object in hasObjectsSet) {
        if ([object.updatedAt compare:[NSDate dateWithTimeIntervalSinceNow:-1]] == NSOrderedAscending)
            [object setObjectFreeFromHolder:holderClass];
    }
}

- (NSInteger)getObjectModelType {
    NSInteger modelType = -1;
    if ([self isKindOfClass:[BillboardPost class]]) {
        modelType = WTSDKBillboard;
    } else if ([self isKindOfClass:[Activity class]]) {
        modelType = WTSDKActivity;
    } else if ([self isKindOfClass:[News class]]) {
        modelType = WTSDKInformation;
    } else if ([self isKindOfClass:[Star class]]) {
        modelType = WTSDKStar;
    } else if ([self isKindOfClass:[Organization class]]) {
        modelType = WTSDKOrganization;
    } else if ([self isKindOfClass:[User class]]) {
        modelType = WTSDKUser;
    } else if ([self isKindOfClass:[Course class]]) {
        modelType = WTSDKCourse;
    }
    return modelType;
}

+ (NSInteger)convertObjectClassToModelType:(NSString *)objectClass {
    NSInteger modelType = -1;
    if ([objectClass isEqualToString:@"BillboardPost"]) {
        modelType = WTSDKBillboard;
    } else if ([objectClass isEqualToString:@"Activity"]) {
        modelType = WTSDKActivity;
    } else if ([objectClass isEqualToString:@"News"]) {
        modelType = WTSDKInformation;
    } else if ([objectClass isEqualToString:@"Star"]) {
        modelType = WTSDKStar;
    } else if ([objectClass isEqualToString:@"Organization"]) {
        modelType = WTSDKOrganization;
    } else if ([objectClass isEqualToString:@"User"]) {
        modelType = WTSDKUser;
    } else if ([objectClass isEqualToString:@"Course"]) {
        modelType = WTSDKCourse;
    }
    return modelType;
}

@end
