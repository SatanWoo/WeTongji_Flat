//
//  WTRootViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTRootViewController.h"
#import "WTInnerNotificationViewController.h"
#import "WTCoreDataManager.h"
#import "WTLoginViewController.h"

@interface WTRootViewController ()

@end

@implementation WTRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configureRootViewUI];
}

#pragma mark - UI methods

- (void)configureRootViewUI {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
    self.navigationItem.leftBarButtonItem = self.notificationButton;
}

#pragma mark - Properties

- (WTNotificationBarButton *)notificationButton {
    if (_notificationButton == nil) {
        _notificationButton = [WTNotificationBarButton createNotificationBarButtonWithTarget:self action:@selector(didClickNotificationButton:)];
    }
    return _notificationButton;
}

#pragma mark - Actions

- (void)didClickNotificationButton:(WTNotificationBarButton *)sender {
    if (![WTCoreDataManager sharedManager].currentUser) {
        [WTLoginViewController showWithIntro:NO];
        return;
    }
    
    WTRootNavigationController *nav = (WTRootNavigationController *)self.navigationController;
    
    if (!sender.selected) {
        sender.selected = YES;
        
        WTInnerNotificationViewController *vc = [WTInnerNotificationViewController sharedViewController];
        [nav showInnerModalViewController:vc sourceViewController:self disableNavBarType:WTDisableNavBarTypeRight];
        [sender stopShine];
        
    } else {
        [nav hideInnerModalViewController];
    }
}

#pragma mark - WTRootNavigationControllerDelegate

- (void)didHideInnderModalViewController {
    self.notificationButton.selected = NO;
}

@end
