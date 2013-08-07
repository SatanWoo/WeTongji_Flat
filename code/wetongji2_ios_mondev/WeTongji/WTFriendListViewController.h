//
//  WTFriendListViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-11.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTCoreDataTableViewController.h"

@interface WTFriendListViewController : WTCoreDataTableViewController

+ (WTFriendListViewController *)createViewControllerWithUser:(User *)user
                                              backButtonText:(NSString *)backButtonText;

@end
