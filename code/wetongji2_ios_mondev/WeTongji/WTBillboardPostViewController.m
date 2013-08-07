//
//  WTBillboardPostViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-17.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBillboardPostViewController.h"
#import "WTResourceFactory.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "WTBillboardPostPlainTextViewController.h"
#import "WTBillboardPostImageViewController.h"
#import "UIApplication+WTAddition.h"
#import "WTNavigationViewController.h"

@interface WTBillboardPostViewController ()

@end

@implementation WTBillboardPostViewController

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
	// Do any additional setup after loading the view.
    [self configureNavigationBar];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)show {
    WTNavigationViewController *nav = [[WTNavigationViewController alloc] initWithRootViewController:self];
    [[UIApplication sharedApplication].rootTabBarController presentViewController:nav animated:YES completion:nil];
}

+ (WTBillboardPostViewController *)createPostViewControllerWithType:(WTBillboardPostViewControllerType)type {
    WTBillboardPostViewController *result = nil;
    if (type == WTBillboardPostViewControllerTypePlainText) {
        result = [[WTBillboardPostPlainTextViewController alloc] init];
    } else if (type == WTBillboardPostViewControllerTypeImage) {
        result = [[WTBillboardPostImageViewController alloc] init];
    }
    return result;
}

#pragma mark - UI methods

- (void)configurePostBarButton {
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createFocusBarButtonWithText:NSLocalizedString(@"Post", nil) target:self action:@selector(didClickPostButton:)];
}

- (void)configureNavigationBar {
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Cancel", nil) target:self action:@selector(didClickCancelButton:)];
    
    [self configurePostBarButton];
}

- (void)dismissView {
    [[UIApplication sharedApplication].rootTabBarController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (void)didClickCancelButton:(UIButton *)sender {
    [self dismissView];
}

- (void)didClickPostButton:(UIButton *)sender {
    if (self.titleTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入标题" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
        return;
    }
    if ([self isKindOfClass:[WTBillboardPostImageViewController class]]) {
        if (self.postImageView.image == nil) {
            [[[UIAlertView alloc] initWithTitle:@"错误" message:@"请添加照片" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
            return;
        }
    } else if ([self isKindOfClass:[WTBillboardPostPlainTextViewController class]]) {
        if (self.contentTextView.text.length == 0) {
            [[[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入内容" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
            return;
        }
    }
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        [self configurePostBarButton];
        [self dismissView];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Post failed for reason:%@", error.localizedDescription);
        [self configurePostBarButton];
    }];
    [request addBillboardPostWithTitle:self.titleTextField.text content:self.contentTextView.text image:self.postImageView.image];
    [[WTClient sharedClient] enqueueRequest:request];
    
    [WTResourceFactory configureActivityIndicatorBarButton:self.navigationItem.rightBarButtonItem activityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}

@end
