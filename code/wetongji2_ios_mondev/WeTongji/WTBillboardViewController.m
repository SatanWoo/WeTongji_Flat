//
//  WTBillboardViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBillboardViewController.h"
#import "WTResourceFactory.h"
#import "UIApplication+WTAddition.h"
#import "WTBillboardTableViewController.h"
#import "BillboardPost.h"
#import "WTBillboardPostViewController.h"
#import "WTBillboardDetailViewController.h"
#import "WTLoginViewController.h"

@interface WTBillboardViewController ()

@property (nonatomic, strong) WTBillboardTableViewController *tableViewController;

@end

@implementation WTBillboardViewController

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
    // Do any additional setup after loading the view from its nib.
    [self configureTableViewController];
    [self configureNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableViewController viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.tableViewController viewDidDisappear:animated];
}

#pragma mark - Public methods

- (void)showBillboardDetailViewWithBillboardPost:(BillboardPost *)post {
    WTBillboardDetailViewController *vc = [WTBillboardDetailViewController createBillboardDetailViewControllerWithBillboardPost:post backBarButtonText:NSLocalizedString(@"Billboard", nil)];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Properties

- (WTBillboardTableViewController *)tableViewController {
    if (!_tableViewController) {
        _tableViewController = [[WTBillboardTableViewController alloc] init];
    }
    return _tableViewController;
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Billboard", nil)];
    
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createNewPostBarButtonWithTarget:self action:@selector(didClickNewPostButton:)];
}

- (void)configureTableViewController {
    self.tableViewController.view.frame = self.view.frame;
    [self.view addSubview:self.tableViewController.view];
}

#pragma mark - Actions

- (void)didClickNewPostButton:(UIButton *)sender {
    
    if (![WTCoreDataManager sharedManager].currentUser) {
        [WTLoginViewController showWithIntro:NO];
        return;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Photo", nil), NSLocalizedString(@"Text", nil), NSLocalizedString(@"WeTongji Q&A", nil), nil];
    [actionSheet showFromTabBar:[UIApplication sharedApplication].rootTabBarController.tabBar];
}

enum {
    ActionSheetImageButtonIndex,
    ActionSheetPlainTextButtonIndex,
    ActionSheetWeTongjiQAndAButtonIndex,
};

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case ActionSheetImageButtonIndex:
        {
            WTBillboardPostViewController *vc = [WTBillboardPostViewController createPostViewControllerWithType:WTBillboardPostViewControllerTypeImage];
            [vc show];
        }
            break;
        case ActionSheetPlainTextButtonIndex:
        {
            WTBillboardPostViewController *vc = [WTBillboardPostViewController createPostViewControllerWithType:WTBillboardPostViewControllerTypePlainText];
            [vc show];
        }
            break;
            
        default:
            break;
    }
}

@end
