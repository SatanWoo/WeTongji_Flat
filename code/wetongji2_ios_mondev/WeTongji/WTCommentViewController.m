//
//  WTCommentViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCommentViewController.h"
#import "WTResourceFactory.h"
#import "Object+Addition.h"
#import "UIApplication+WTAddition.h"
#import "WTNavigationViewController.h"

#define MAX_COMMENT_TEXT_LENGTH 140

@interface WTCommentViewController () <UITextViewDelegate>

@property (nonatomic, strong) Object *commentObject;

@property (nonatomic, weak) UILabel *navigationBarTitleLable;

@end

@implementation WTCommentViewController

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
    [self configureContentView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)showViewControllerWithCommentObject:(Object *)commentObject {
    WTCommentViewController *result = [[WTCommentViewController alloc] init];
    
    WTNavigationViewController *nav = [[WTNavigationViewController alloc] initWithRootViewController:result];
    
    result.commentObject = commentObject;
    
    [[UIApplication sharedApplication].rootTabBarController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Keyboard notification

- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGFloat keyboardHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self configureContentTextViewSizeWithKeyboardHeight:keyboardHeight];
}

#pragma mark - Actions

- (void)didClickCancelButton:(UIButton *)sender {
    [self dismissView];
}

- (void)didClickPostButton:(UIButton *)sender {
    NSString *commentBody = self.contentTextView.text;
    if ([commentBody isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入内容。" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
    } else {
        WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
            WTLOG(@"Comment success:%@", responseObject);
            [self dismissView];
        } failureBlock:^(NSError *error) {
            [WTErrorHandler handleError:error];
        }];
        
        [request commentModel:[self.commentObject getObjectModelType] modelID:self.commentObject.identifier commentBody:commentBody];
        [[WTClient sharedClient] enqueueRequest:request];
    }
}

#pragma mark - UI methods 

- (void)dismissView {
    [[UIApplication sharedApplication].rootTabBarController dismissViewControllerAnimated:YES completion:nil];
}

- (void)configureNavigationBar {
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Cancel", nil) target:self action:@selector(didClickCancelButton:)];
    
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createFocusBarButtonWithText:NSLocalizedString(@"Post", nil) target:self action:@selector(didClickPostButton:)];
    
    // TODO: 不规范
    UIView *titleView = [WTResourceFactory createNavigationBarTitleViewWithText:[NSString stringWithFormat:@"0/%d", MAX_COMMENT_TEXT_LENGTH]];
    self.navigationBarTitleLable = titleView.subviews.lastObject;
    self.navigationItem.titleView = titleView;
}

- (void)configureContentView {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.contentBgImageView.image = bgImage;
    
    [self.contentTextView becomeFirstResponder];
}

- (void)configureContentTextViewSizeWithKeyboardHeight:(CGFloat)keyboardHeight {
    CGFloat visibleScreenHeight = self.view.frame.size.height - keyboardHeight;
    CGRect contentTextViewFrameInRootView = [self.view convertRect:self.contentTextView.frame fromView:self.contentTextView.superview];
    CGFloat contentTextViewHeight = visibleScreenHeight - contentTextViewFrameInRootView.origin.y;
    [self.contentTextView resetHeight:contentTextViewHeight];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > MAX_COMMENT_TEXT_LENGTH) {
        textView.text = [textView.text substringToIndex:MAX_COMMENT_TEXT_LENGTH];
    }
    self.navigationBarTitleLable.text = [NSString stringWithFormat:@"%d/%d", textView.text.length, MAX_COMMENT_TEXT_LENGTH];
}

@end
