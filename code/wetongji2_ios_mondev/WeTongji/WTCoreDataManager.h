//
//  WTCoreDataManager.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"

@interface WTCoreDataManager : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) User *currentUser;

+ (WTCoreDataManager *)sharedManager;

- (BOOL)isCurrentUserInfoDifferentFromDefaultInfo;

- (void)configureCurrentUserDefaultInfo;

- (void)eraseAllData;
- (void)saveContext;

@end
