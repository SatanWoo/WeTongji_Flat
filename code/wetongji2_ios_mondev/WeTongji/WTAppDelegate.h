//
//  WTAppDelegate.h
//  WeTongji
//
//  Created by 王 紫川 on 12-11-6.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;

@property (strong, nonatomic) IBOutlet UITabBarController *tabBarController;

@end
