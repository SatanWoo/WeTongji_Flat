//
//  WTTermOfUseViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTTermOfUseViewController.h"
#import "UIApplication+WTAddition.h"
#import "WTNavigationViewController.h"
#import "WTResourceFactory.h"

@interface WTTermOfUseViewController ()

@property (nonatomic, copy) NSString *backButtonText;

@end

@implementation WTTermOfUseViewController

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
    [self configureNavigationBar];
}

+ (WTTermOfUseViewController *)createViewControllerWithBackButtonText:(NSString *)backButtonText {
    WTTermOfUseViewController *result = [[WTTermOfUseViewController alloc] init];
    
    result.backButtonText = backButtonText;
    
    return result;
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createBackBarButtonWithText:self.backButtonText target:self action:@selector(didClickBackButton:)];
    
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Term of Use", nil)];
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
