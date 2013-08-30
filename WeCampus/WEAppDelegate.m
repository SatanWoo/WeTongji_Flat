//
//  WEAppDelegate.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-10.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEAppDelegate.h"
#import "WTClient.h"
#import "WTRequest.h"
#import "WTCoreDataManager.h"
#import "User+Addition.h"

@implementation WEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.window makeKeyAndVisible];
    [self logIn];

    return YES;
}

- (void)logIn
{
    WTClient *client = [WTClient sharedClient];
    WTRequest *request = [WTRequest requestWithSuccessBlock: ^(id responseData)
                          {
                              User *user = [User insertUser:[responseData objectForKey:@"User"]];
                              NSLog(@"user is %@", user);
                              [WTCoreDataManager sharedManager].currentUser = user;
                          } failureBlock:^(NSError * error) {
                          }];
    [request loginWithStudentNumber:@"092988" password:@"tongjiwuziqi"];
    [client enqueueRequest:request];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[WTCoreDataManager sharedManager] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[WTCoreDataManager sharedManager] saveContext];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

- (void)hideTabbar
{
    [self.rootTabBarController hideTabBar];
}

- (void)showTabbar
{
    [self.rootTabBarController showTabBar];
}

@end
