//
//  WTInnerNotificationTableViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTInnerNotificationViewController.h"
#import "WTCoreDataTableViewController.h"
#import "WTNotificationCell.h"

@protocol WTInnerNotificationTableViewControllerDelegate;

@interface WTInnerNotificationTableViewController : WTCoreDataTableViewController <WTNotificationCellDelegate>

@property (nonatomic, weak) id<WTInnerNotificationTableViewControllerDelegate> delegate;

@end

@protocol WTInnerNotificationTableViewControllerDelegate <NSObject>

- (void)innerNotificaionTableViewController:(WTInnerNotificationTableViewController *)vc
                   wantToPushViewController:(UIViewController *)pushVC;

@end
