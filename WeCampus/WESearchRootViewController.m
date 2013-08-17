//
//  WESearchRootViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-17.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WESearchRootViewController.h"
#import "WTSearchDefaultViewController.h"
#import "NSUserDefaults+WTAddition.h"
#import <QuartzCore/QuartzCore.h>

@interface WESearchRootViewController () <UITextFieldDelegate>
@property (strong, nonatomic) WTSearchDefaultViewController *defaultViewController;
@end

@implementation WESearchRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureSearchBar];
    [self configureDefaultView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#define kSearchbarEditinWidth 230
#define kSearchbarNotEditingWidth 305
#define kCancelButtonAppearX 244

- (void)configureSearchBar
{
    [self.cancelButton resetOriginX:self.searchBarContainerView.frame.size.width];
    [self.textFieldContainerView resetWidth:kSearchbarNotEditingWidth];
    self.searchBarContainerView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.8].CGColor;
}

- (void)configureDefaultView {
    self.defaultViewController = [[WTSearchDefaultViewController alloc] init];
    [self.defaultViewController.view resetHeight:self.resultContainerView.frame.size.height];
    [self.resultContainerView addSubview:self.defaultViewController.view];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5f animations:^{
        [self.textFieldContainerView resetWidth:kSearchbarEditinWidth];
        [self.cancelButton resetOriginX:kCancelButtonAppearX];
    } completion:^(BOOL finished) {
    }];
    
    [textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[NSUserDefaults standardUserDefaults] addSearchHistoryItemWithSearchKeyword:textField.text searchCategory:0];
    return YES;
}

- (IBAction)didClickCancelButton:(id)sender
{
    [UIView animateWithDuration:0.5f animations:^{
        [self.textFieldContainerView resetWidth:kSearchbarNotEditingWidth];
        [self.cancelButton resetOriginX:self.searchBarContainerView.frame.size.width];
    } completion:^(BOOL finished) {
    }];
    
    [self.searchBarTextField resignFirstResponder];
}

@end
