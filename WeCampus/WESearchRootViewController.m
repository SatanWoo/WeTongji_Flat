//
//  WESearchRootViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-17.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WESearchRootViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface WESearchRootViewController () <UITextFieldDelegate>

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#define kSearchbarEditinX 230
#define kSearchbarNotEditingX 305

- (void)configureSearchBar
{
    self.cancelButton.hidden = YES;
    [self.searchBarTextField resetWidth:kSearchbarNotEditingX];
    self.searchBarContainerView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.8].CGColor;
    [self.searchBarTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5f animations:^{
        [self.searchBarTextField resetWidth:kSearchbarEditinX];
    } completion:^(BOOL finished) {
        self.cancelButton.hidden = NO;
    }];
    
    [textField becomeFirstResponder];
}

@end
