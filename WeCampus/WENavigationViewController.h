//
//  WENavigationViewController.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-11.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WERootViewController;

@interface WENavigationViewController : UINavigationController

@property (strong, nonatomic) WERootViewController *rootViewController;

- (void)initRootViewController;
- (void)configureNavigationBar;

@end
