//
//  WEAppDelegate.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-10.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTRootTabBarController.h"

@interface WEAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;

@property (strong, nonatomic) IBOutlet UITabBarController *tabBarController;

@property (strong, nonatomic) IBOutlet WTRootTabBarController *rootTabBarController;
@end
