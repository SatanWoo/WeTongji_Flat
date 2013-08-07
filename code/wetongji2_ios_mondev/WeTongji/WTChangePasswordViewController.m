//
//  WTChangePasswordViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTChangePasswordViewController.h"
#import "WTResourceFactory.h"

@interface WTChangePasswordViewController ()

@end

@implementation WTChangePasswordViewController

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
    [self configureInfoPanel];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
    
    [self.oldPasswordTextField becomeFirstResponder];
}

#pragma mark - UI methods

- (void)configureRightNavigationBarButtonItem {
    UIBarButtonItem *getPasswordBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Change Password", nil) target:self action:@selector(didClickChangePasswordButton:)];
    self.navigationItem.rightBarButtonItem = getPasswordBarButtonItem;
}

- (void)configureNavigationBar {
    UIBarButtonItem *backBarButtonItem = [WTResourceFactory createBackBarButtonWithText:NSLocalizedString(@"Setting", nil) target:self action:@selector(didClickBackButton:) restrictToMaxWidth:NO];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    [self configureRightNavigationBarButtonItem];
}

- (void)configureInfoPanel {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.panelBgImageView.image = bgImage;
    
    self.oldPasswordTextField.placeholder = NSLocalizedString(@"Current Password", nil);
    self.passwordTextField.placeholder = NSLocalizedString(@"New Password", nil);
    self.repeatPasswordTextField.placeholder = NSLocalizedString(@"Repeat Password", nil);;
}

- (void)showChangePasswordSuccessAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil)
                                                    message:NSLocalizedString(@"You have successfully changed your password", nil)
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"I see", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Logic methods

- (BOOL)checkUserInput {
    if ([self.oldPasswordTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                        message:NSLocalizedString(@"Please enter your current password", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"I see", nil)
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    } else if ([self.passwordTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                        message:NSLocalizedString(@"Please enter your new password", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"I see", nil)
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    } else if (![self.passwordTextField.text isEqualToString:self.repeatPasswordTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                        message:NSLocalizedString(@"The passwords you entered do not match. Please re-enter your passwords.", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"I see", nil)
                                              otherButtonTitles:nil];
        [alert show];
        return  NO;
    }
    return YES;
}

#pragma mark - Actions

- (void)didClickChangePasswordButton:(UIButton *)sender {
    if (![self checkUserInput])
        return;
    
    [WTResourceFactory configureActivityIndicatorBarButton:self.navigationItem.rightBarButtonItem activityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.view.userInteractionEnabled = NO;
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Change password succeeded:%@", responseObject);
        [self configureRightNavigationBarButtonItem];
        [self.navigationController popViewControllerAnimated:YES];
        
        [self showChangePasswordSuccessAlert];
        
    } failureBlock:^(NSError *error) {
        [self configureRightNavigationBarButtonItem];
        [WTErrorHandler handleError:error];
        self.view.userInteractionEnabled = YES;
    }];
    [request updatePassword:self.passwordTextField.text oldPassword:self.oldPasswordTextField.text];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.oldPasswordTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.repeatPasswordTextField becomeFirstResponder];
    } else {
        [self didClickChangePasswordButton:nil];
    }
    return NO;
}

@end
