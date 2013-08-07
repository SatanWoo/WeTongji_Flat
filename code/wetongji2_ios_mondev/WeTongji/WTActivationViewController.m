//
//  WTActivationViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTActivationViewController.h"
#import "WTResourceFactory.h"
#import "OHAttributedLabel.h"
#import "WTTermOfUseViewController.h"

@interface WTActivationViewController () <OHAttributedLabelDelegate, UITextFieldDelegate>

@end

@implementation WTActivationViewController

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
    [self configureActivationGuideLabel];
    [self configureInfoPanel];
    [self configureAgreementLabel];
    [self configureScrollView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard notification

- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGFloat keyboardHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self.scrollView resetHeight:self.view.frame.size.height - keyboardHeight];
}

#pragma mark - UI methods

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.agreementDisplayLabel.frame.origin.y + self.agreementDisplayLabel.frame.size.height);
}

- (void)configureActivationGuideLabel {
    self.activationGuideDisplayLabel.text = NSLocalizedString(@"WeTongji currently support undergraduate and postgraduate users. To activate your WeTongji account, you need to register your @tongji.edu.cn email account first. By providing your Student No. and Name, a verification email will be sent to your Tongji email account upon activation.", nil);
    [self.activationGuideDisplayLabel resetOriginY:0];
    [self.activationGuideDisplayLabel sizeToFit];
    [self.activationGuideDisplayLabel resetCenterX:self.view.frame.size.width / 2];
}

- (void)configureRightNavigationBarButtonItem {
    UIBarButtonItem *nextBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Activate", nil) target:self action:@selector(didClickActivateButton:)];
    self.navigationItem.rightBarButtonItem = nextBarButtonItem;

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
    self.passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
    self.repeatPasswordTextField.placeholder = NSLocalizedString(@"Repeat Password", nil);
    
    [self.infoPanelContainerView resetOriginY:self.activationGuideDisplayLabel.frame.size.height + 10.0f];
}

- (void)configureAgreementLabel {
    NSString *agreementString = NSLocalizedString(@"By tapping Activate you are indicating that you have read and agree to Term of Use", nil);
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:agreementString];
    [resultString setAttributes:[self.agreementDisplayLabel.attributedText attributesAtIndex:0 effectiveRange:NULL] range:NSMakeRange(0, resultString.length)];
    
    NSString *termOfUseString = NSLocalizedString(@"Term of Use", nil);
    [resultString setTextBold:YES range:NSMakeRange(resultString.length - termOfUseString.length, termOfUseString.length)];
    [resultString setTextIsUnderlined:YES range:NSMakeRange(resultString.length - termOfUseString.length, termOfUseString.length)];
    
    NSRegularExpression* userRegex = [NSRegularExpression regularExpressionWithPattern:termOfUseString options:0 error:nil];
    [userRegex enumerateMatchesInString:agreementString
                                options:0
                                  range:NSMakeRange(0, agreementString.length)
                             usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop)
     {
         NSString* linkURLString = [NSString stringWithFormat:@"agreement:agreement"];
         [resultString setLink:[NSURL URLWithString:linkURLString] range:match.range];
         *stop = YES;
     }];
    
    self.agreementDisplayLabel.attributedText = resultString;
    self.agreementDisplayLabel.delegate = self;
    
    self.agreementDisplayLabel.linkColor = [UIColor darkGrayColor];
    
    CGFloat agreementLabelHeight = [resultString sizeConstrainedToSize:CGSizeMake(self.agreementDisplayLabel.frame.size.width, 200000.0f)].height;
    [self.agreementDisplayLabel resetHeight:agreementLabelHeight];
    
    [self.agreementDisplayLabel sizeToFit];
    [self.agreementDisplayLabel resetOriginY:self.infoPanelContainerView.frame.origin.y + self.infoPanelContainerView.frame.size.height + 10.0f];
    [self.agreementDisplayLabel resetCenterX:self.view.frame.size.width / 2];
}

- (void)showActivationSuccessAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil)
                                                    message:[NSString stringWithFormat:@"%@ %@@tongji.edu.cn", NSLocalizedString(@"A verification email has been sent to", nil), self.accountTextField.text]
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"I see", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)adjustScrollViewContentOffset {
    [UIView animateWithDuration:0.25f animations:^{
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentSize.height + self.scrollView.contentInset.bottom - self.scrollView.frame.size.height);
    }];
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
        return  NO;
    } else if ([self.nameTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                        message:NSLocalizedString(@"Please enter your Name", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"I see", nil)
                                              otherButtonTitles:nil];
        [alert show];
        return  NO;
    } else if ([self.passwordTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                        message:NSLocalizedString(@"Please enter your Password", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"I see", nil)
                                              otherButtonTitles:nil];
        [alert show];
        return  NO;
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

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didClickActivateButton:(UIButton *)sender {
    if (![self checkUserInput])
        return;
    
    [WTResourceFactory configureActivityIndicatorBarButton:self.navigationItem.rightBarButtonItem activityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.view.userInteractionEnabled = NO;
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Reset password succeeded:%@", responseObject);
        [self configureRightNavigationBarButtonItem];
        [self.navigationController popViewControllerAnimated:YES];
        
        [self showActivationSuccessAlert];
        
    } failureBlock:^(NSError *error) {
        [self configureRightNavigationBarButtonItem];
        [WTErrorHandler handleError:error];
        self.view.userInteractionEnabled = YES;
    }];
    [request activateUserWithStudentNumber:self.accountTextField.text password:self.passwordTextField.text name:self.nameTextField.text];
    [[WTClient sharedClient] enqueueRequest:request];
}

#pragma mark - OHAttributedStringDelegate

- (BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel
       shouldFollowLink:(NSTextCheckingResult *)linkInfo {
	if ([linkInfo.URL.scheme isEqualToString:@"agreement"]) {
        WTTermOfUseViewController *vc = [WTTermOfUseViewController createViewControllerWithBackButtonText:NSLocalizedString(@"Activation", nil)];
        [self.navigationController pushViewController:vc animated:YES];
    }
    // Prevent the URL from opening in Safari, as we handled it here manually instead
    return NO;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextField) {
        [self.passwordTextField becomeFirstResponder];
        [self adjustScrollViewContentOffset];
    } else if (textField == self.passwordTextField) {
        [self.repeatPasswordTextField becomeFirstResponder];
        [self adjustScrollViewContentOffset];
    } else if (textField == self.repeatPasswordTextField) {
        [self didClickActivateButton:nil];
    }
    
    return NO;
}

@end
