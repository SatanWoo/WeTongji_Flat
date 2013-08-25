//
//  WEModifyPasswordViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-25.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEModifyPasswordViewController.h"

@interface WEModifyPasswordViewController ()

@end

@implementation WEModifyPasswordViewController

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
    [self configureTextField];
    // Do any additional setup after loading the view from its nib.
}

- (void)configureTextField
{
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 5);
    [self.oldPassword becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)resignAllFirstResponder
{
    [self.confirmPassword resignFirstResponder];
    [self.password resignFirstResponder];
    [self.oldPassword resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.oldPassword) {
        [self.password becomeFirstResponder];
    } else if(textField == self.password) {
        [self.confirmPassword becomeFirstResponder];
    } else {
        [self resignAllFirstResponder];
    }
    return NO;
}

@end
