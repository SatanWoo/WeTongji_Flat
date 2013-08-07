//
//  WTLoginViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTLoginViewController.h"
#import "WTNavigationViewController.h"
#import "UIApplication+WTAddition.h"
#import "WTResourceFactory.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "User+Addition.h"
#import "WTCoreDataManager.h"
#import "WTLoginIntroViewController.h"
#import "WTActivationViewController.h"
#import "WTForgetPasswordViewController.h"

@interface WTLoginViewController ()

@property (nonatomic, strong) UIButton *forgetPasswordButton;
@property (nonatomic, strong) WTLoginIntroViewController *introViewController;
@property (nonatomic, assign) BOOL showIntro;
@property (nonatomic, assign) BOOL isLoggingIn;

@end

@implementation WTLoginViewController

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
    [self configureLoginPanel];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.showIntro) {
        [self.view addSubview:self.introViewController.view];
        [self.introViewController resetFrame:self.view.frame];
    }
}

#pragma mark - Properties

- (WTLoginIntroViewController *)introViewController {
    if (!_introViewController) {
        _introViewController = [[WTLoginIntroViewController alloc] init];
    }
    return _introViewController;
}

- (UIButton *)forgetPasswordButton {
    if (_forgetPasswordButton == nil) {
        _forgetPasswordButton = [WTResourceFactory createNormalButtonWithText:NSLocalizedString(@"Forgot?", nil)];
        [_forgetPasswordButton resetCenterY:self.passwordTextField.center.y];
        
        CGFloat containerViewWidth = self.loginPanelContainerView.frame.size.width;
        CGFloat textfieldOriginX = self.accountTextField.frame.origin.x;
        CGFloat forgetButtonDisToRightBorder = 10;
        [_forgetPasswordButton resetOriginX:containerViewWidth - forgetButtonDisToRightBorder - _forgetPasswordButton.frame.size.width];
        
        [self.passwordTextField resetWidth:containerViewWidth - _forgetPasswordButton.frame.size.width - textfieldOriginX - forgetButtonDisToRightBorder * 2];
    }
    return _forgetPasswordButton;
}

#pragma - UI methods

- (void)configureLoginPanel {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.loginPanelBgImageView.image = bgImage;
    
    self.accountTextField.placeholder = NSLocalizedString(@"Student No.", nil);
    self.passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
    
    [self.loginPanelContainerView addSubview:self.forgetPasswordButton];
    [self.forgetPasswordButton addTarget:self action:@selector(didClickForgetPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.showIntro)
        [self.accountTextField becomeFirstResponder];
    
    [self.signUpButton setTitle:NSLocalizedString(@"Sign Up", nil) forState:UIControlStateNormal];
}

- (void)configureShowIntroBarButton {
    UIButton *introButton = [WTResourceFactory createFocusButtonWithText:NSLocalizedString(@"Log In / Sign Up", nil)];
    introButton.selected = self.showIntro;
    [introButton addTarget:self action:@selector(didClickIntroButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *introBarButtonItem = [WTResourceFactory createBarButtonWithButton:introButton];
    self.navigationItem.rightBarButtonItem = introBarButtonItem;
}

- (void)configureNavigationBar {
    UIBarButtonItem *cancalBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Not now", nil) target:self action:@selector(didClickCancelButton:)];
    self.navigationItem.leftBarButtonItem = cancalBarButtonItem;
    
    [self configureShowIntroBarButton];
}

#pragma mark - Animations

- (void)showIntroViewAnimationWithCompletion:(void (^)(void))completion {
    [self.view addSubview:self.introViewController.view];
    [self.introViewController resetFrame:self.view.frame];
    
    [self.introViewController.view resetOriginY:self.view.frame.size.height];
    [UIView animateWithDuration:0.25f animations:^{
        [self.introViewController.view resetOriginY:0];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)hideIntroViewAnimationWithCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:0.25 animations:^{
        [self.introViewController.view resetOriginY:self.view.frame.size.height];
    } completion:^(BOOL finished) {
        [self.introViewController.view removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - Actions

- (void)didClickForgetPasswordButton:(UIButton *)sender {
    WTForgetPasswordViewController *vc = [[WTForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickCancelButton:(UIButton *)sender {
    [self dismissView];
}

- (void)didClickIntroButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.showIntro = sender.selected;
    
    sender.userInteractionEnabled = NO;
    
    if (sender.selected) {
        [self showIntroViewAnimationWithCompletion:^{
            sender.userInteractionEnabled = YES;
        }];
        [self.view endEditing:YES];
    } else {
        [self hideIntroViewAnimationWithCompletion:^{
            sender.userInteractionEnabled = YES;
        }];
        [self.accountTextField becomeFirstResponder];
    }
}

- (IBAction)didClickSignUpButton:(UIButton *)sender {
    WTActivationViewController *vc = [[WTActivationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

+ (WTLoginViewController *)showWithIntro:(BOOL)showIntro {
    WTLoginViewController *vc = [[WTLoginViewController alloc] init];
    WTNavigationViewController *nav = [[WTNavigationViewController alloc] initWithRootViewController:vc];
    vc.showIntro = showIntro;
    
    UIViewController *rootVC = [UIApplication sharedApplication].rootTabBarController;
    [rootVC presentViewController:nav animated:YES completion:nil];
    
    return vc;
}

- (void)dismissView {
    UIViewController *rootVC = [UIApplication sharedApplication].rootTabBarController;
    [rootVC dismissViewControllerAnimated:YES completion:^{
        [self.delegate loginViewControllerDidDismiss];
    }];
}

#pragma mark - Logic methods

- (void)configureFlurryUserData:(User *)user {
    [Flurry setGender:user.gender];
    [Flurry setUserID:user.studentNumber];
}

- (void)login {
    if (self.isLoggingIn)
        return;
    self.isLoggingIn = YES;
    WTClient *client = [WTClient sharedClient];
    WTRequest *request = [WTRequest requestWithSuccessBlock: ^(id responseData) {
        WTLOG(@"Login success:%@", responseData);
        User *user = [User insertUser:[responseData objectForKey:@"User"]];
        [WTCoreDataManager sharedManager].currentUser = user;
        [self configureFlurryUserData:user];
        [self configureShowIntroBarButton];
        [self dismissView];
    } failureBlock:^(NSError * error) {
        self.isLoggingIn = NO;
        [WTErrorHandler handleError:error];
        [self configureShowIntroBarButton];
    }];
    [request loginWithStudentNumber:self.accountTextField.text password:self.passwordTextField.text];
    [client enqueueRequest:request];
    
    [WTResourceFactory configureActivityIndicatorBarButton:self.navigationItem.rightBarButtonItem activityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.passwordTextField) {
        [self login];
    }
    return NO;
}

@end
