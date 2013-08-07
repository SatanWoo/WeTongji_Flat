//
//  WTCoreDataManager.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCoreDataManager.h"
#import "User+Addition.h"
#import <WeTongjiSDK/NSUserDefaults+WTSDKAddition.h>
#import "NSNotificationCenter+WTAddition.h"
#import "NSUserDefaults+WTAddition.h"
#import "Object+Addition.h"

@interface WTCoreDataManager()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation WTCoreDataManager

@synthesize currentUser = _currentUser;

#pragma mark - Constructors

+ (WTCoreDataManager *)sharedManager {
    static WTCoreDataManager *manager = nil;
    static dispatch_once_t WTCoreDataMangerPredicate;
    dispatch_once(&WTCoreDataMangerPredicate, ^{
        manager = [[WTCoreDataManager alloc] init];
    });
    
    return manager;
}

- (void)configureCurrentUserDefaultInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setCurrentUserMotto:_currentUser.motto];
    [defaults setCurrentUserPhone:_currentUser.phoneNumber];
    [defaults setCurrentUserEmail:_currentUser.emailAddress];
    [defaults setCurrentUserQQ:_currentUser.qqAccount];
    [defaults setCurrentUserSinaWeibo:_currentUser.sinaWeiboName];
    [defaults setCurrentUserDorm:_currentUser.dormString];
}

- (BOOL)isCurrentUserInfoDifferentFromDefaultInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![[defaults getCurrentUserMotto] isEqualToString:self.currentUser.motto])
        return YES;
    if (![[defaults getCurrentUserPhone] isEqualToString:self.currentUser.phoneNumber])
        return YES;
    if (![[defaults getCurrentUserEmail] isEqualToString:self.currentUser.emailAddress])
        return YES;
    if (![[defaults getCurrentUserQQ] isEqualToString:self.currentUser.qqAccount])
        return YES;
    if (![[defaults getCurrentUserSinaWeibo] isEqualToString:self.currentUser.sinaWeiboName])
        return YES;
    if (![[defaults getCurrentDorm] isEqualToString:self.currentUser.dormString])
        return YES;
    return NO;
}

#pragma mark - Properties

- (User *)currentUser {
    if (!_currentUser) {
        _currentUser = [User userWithID:[NSUserDefaults getCurrentUserID]];
        [self configureCurrentUserDefaultInfo];
        if (_currentUser)
            [NSNotificationCenter postCurrentUserDidChangeNotification];
    }
    return _currentUser;
}

- (void)setCurrentUser:(User *)currentUser {
    if (_currentUser != currentUser) {
        _currentUser = currentUser;
        [self configureCurrentUserDefaultInfo];
        [NSNotificationCenter postCurrentUserDidChangeNotification];
    }
}

#pragma mark - Core Data methods

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)eraseAllData {
    NSPersistentStore *store = nil;
    NSError *error;
    NSURL *storeURL = store.URL;
    NSPersistentStoreCoordinator *storeCoordinator = [self persistentStoreCoordinator];
    [storeCoordinator removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WeTongji" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WeTongji3.sqlite"];
    
    NSError *error = nil;
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
        //abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
