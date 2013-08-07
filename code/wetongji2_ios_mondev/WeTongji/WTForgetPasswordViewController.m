//
//  WTForgetPasswordViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTForgetPasswordViewController.h"
#import "WTResourceFactory.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

@interface WTForgetPasswordViewController () <UITextFieldDelegate>

@end

@implementation WTForgetPasswordViewController

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
    
    [self.accountTextField becomeFirstResponder];
}

#pragma mark - UI methods

- (void)configureRightNavigationBarButtonItem {
    UIBarButtonItem *getPasswordBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Reset Password", nil) target:self action:@selector(didClickResetPasswordButton:)];
    self.navigationItem.rightBarButtonItem = getPasswordBarButtonItem;
}

- (void)configureNavigationBar {
    UIBarButtonItem *backBarButtonItem = [WTResourceFactory createBackBarButtonWithText:NSLocalizedString(@"Log In / Sign Up", nil) target:self action:@selector(didClickBackButton:) restrictToMaxWidth:NO];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    [self configureRightNavigationBarButtonItem];
}

- (void)configureInfoPanel {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.panelBgImageView.image = bgImage;
    
    self.accountTextField.placeholder = NSLocalizedString(@"Student No.", nil);
    self.nameTextField.placeholder = NSLocalizedString(@"Name", nil);
    
    self.resetPasswordGuideDisplayLabel.text = NSLocalizedString(@"Provide your Student No. and Name to reset your WeTongji password", nil);
    [self.resetPasswordGuideDisplayLabel sizeToFit];
    [self.resetPasswordGuideDisplayLabel resetCenterX:self.view.frame.size.width / 2];
}

- (void)showResetPasswordSuccessAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil)
                                                    message:[NSString stringWithFormat:@"%@ %@@tongji.edu.cn", NSLocalizedString(@"A reset-password email has been sent to", nil), self.accountTextField.text]
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"I see", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Logic methods

- (BOOL)checkUserInput {
    if ([self.accountTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                        message:NSLocalizedString(@"Please enter your Student No.", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"I see", nil)
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    } else if ([self.nameTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                        message:NSLocalizedString(@"Please enter your Name", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"I see", nil)
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

#pragma mark - Actions

- (void)didClickResetPasswordButton:(UIButton *)sender {
    if (![self checkUserInput])
        return;
    
    [WTResourceFactory configureActivityIndicatorBarButton:self.navigationItem.rightBarButtonItem activityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.view.userInteractionEnabled = NO;
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Reset password succeeded:%@", responseObject);
        [self configureRightNavigationBarButtonItem];
        [self.navigationController popViewControllerAnimated:YES];
        
        [self showResetPasswordSuccessAlert];
        
    } failureBlock:^(NSError *error) {
        [self configureRightNavigationBarButtonItem];
        [WTErrorHandler handleError:error];
        self.view.userInteractionEnabled = YES;
    }];
    [request resetPasswordWithStudentNumber:self.accountTextField.text name:self.nameTextField.text];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextField) {
        [self didClickResetPasswordButton:nil];
    }
    return NO;
}

@end
