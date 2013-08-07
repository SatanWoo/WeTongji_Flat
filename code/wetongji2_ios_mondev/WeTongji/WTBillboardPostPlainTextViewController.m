//
//  WTBillboardPostPlainTextViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-17.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBillboardPostPlainTextViewController.h"
#import "WTResourceFactory.h"
#import <QuartzCore/QuartzCore.h>

@interface WTBillboardPostPlainTextViewController ()

@end

@implementation WTBillboardPostPlainTextViewController

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
    [self configureTitleView];
    [self configureContentView];
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
    [self configureContentTextViewSizeWithKeyboardHeight:keyboardHeight];
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    [super configureNavigationBar];
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Text", nil)];
}

- (void)configureTitleView {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.titleBgImageView.image = bgImage;
    
    UIButton *lockButton = [WTResourceFactory createLockButtonWithTarget:self action:@selector(didClickLockButton:)];
    [lockButton resetOriginX:self.titleBgView.frame.size.width - lockButton.frame.size.width - 7.0f];
    [lockButton resetCenterY:self.titleBgView.frame.size.height / 2];
    [self.titleBgView addSubview:lockButton];
    
    [self.titleTextField becomeFirstResponder];
}

- (void)configureContentView {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.contentBgImageView.image = bgImage;
    
    // self.contentTextView.layer.borderColor = [UIColor blackColor].CGColor;
    // self.contentTextView.layer.borderWidth = 1.0f;
}

- (void)configureContentTextViewSizeWithKeyboardHeight:(CGFloat)keyboardHeight {
    CGFloat visibleScreenHeight = self.view.frame.size.height - keyboardHeight;
    CGRect contentTextViewFrameInRootView = [self.view convertRect:self.contentTextView.frame fromView:self.contentTextView.superview];
    CGFloat contentTextViewHeight = visibleScreenHeight - contentTextViewFrameInRootView.origin.y;
    [self.contentTextView resetHeight:contentTextViewHeight];
}

#pragma mark - Actions

- (void)didClickLockButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
