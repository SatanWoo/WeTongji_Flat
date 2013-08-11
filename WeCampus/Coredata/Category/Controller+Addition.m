//
//  Controller+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-17.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Controller+Addition.h"
#import "WTCoreDataManager.h"

@implementation Controller (Addition)

+ (NSMutableDictionary *)sharedControllerModelDictionary {
    static NSMutableDictionary *controllerModelDictionary = nil;
    static dispatch_once_t WTControllerModelDictionary;
    dispatch_once(&WTControllerModelDictionary, ^{
        controllerModelDictionary = [NSMutableDictionary dictionary];
    });
    return controllerModelDictionary;
}

+ (Controller *)controllerModelForClass:(Class)className {
    NSString *controllerID = NSStringFromClass(className);
    Controller *cachedController = [Controller sharedControllerModelDictionary][controllerID];
    if (cachedController) {
        return cachedController;
    }
    Controller *result = [Controller controllerWithID:controllerID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Controller" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = controllerID;
    }
    [Controller sharedControllerModelDictionary][controllerID] = result;
    return result;
}

+ (Controller *)controllerWithID:(NSString *)controllerID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Controller" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", controllerID]];
    
    Controller *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

@end
