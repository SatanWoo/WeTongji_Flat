//
//  WESearchRootViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-17.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WESearchRootViewController.h"
#import "WTSearchDefaultViewController.h"
#import "WTSearchResultTableViewController.h"

#import "NSUserDefaults+WTAddition.h"
#import <QuartzCore/QuartzCore.h>

@interface WESearchRootViewController () <UITextFieldDelegate, WTSearchDefaultViewControllerDelegate, WTSearchResultTableViewControllerDelegate>
@property (strong, nonatomic) WTSearchDefaultViewController *defaultViewController;
@property (nonatomic, strong) WTSearchResultTableViewController *resultViewController;
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

#define offset (480 - self.resultContainerView.frame.size.height)
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.resultViewController) {
        [((WEAppDelegate *)[UIApplication sharedApplication].delegate) hideTabbar];
        [self.resultViewController.view resetHeight:self.resultContainerView.frame.size.height];
    }
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
    
    self.searchBarContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.searchBarContainerView.layer.shadowRadius = 3.0f;
    self.searchBarContainerView.layer.shadowOpacity = 0.2f;
    self.searchBarContainerView.layer.shadowOffset = CGSizeMake(0, 0);
    [self.searchBarTextField endEditing:YES];
}

- (void)configureDefaultView {
    self.defaultViewController = [[WTSearchDefaultViewController alloc] init];
    self.defaultViewController.delegate = self;
    [self.defaultViewController.view resetHeight:self.resultContainerView.frame.size.height - 50];
    [self.resultContainerView addSubview:self.defaultViewController.view];
}

- (void)clearSearchResultView
{
    if (self.resultViewController) {
        [self.resultViewController.view removeFromSuperview];
        self.resultViewController = nil;
    }
}

- (void)updateSearchResultViewForSearchKeyword:(NSString *)keyword searchCategory:(NSInteger)category {
    [self clearSearchResultView];
    
    WTSearchResultTableViewController *vc = [WTSearchResultTableViewController createViewControllerWithSearchKeyword:keyword searchCategory:0];
    self.resultViewController = vc;
    self.resultViewController.delegate = self;
    [vc.view resetHeight:self.resultContainerView.frame.size.height];
    [self.resultContainerView insertSubview:vc.view aboveSubview:self.defaultViewController.view];
    
    [self.defaultViewController.historyView reload];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self clearSearchResultView];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.textFieldContainerView resetWidth:kSearchbarEditinWidth];
        [self.cancelButton resetOriginX:kCancelButtonAppearX];
    } completion:^(BOOL finished) {
    }];
    
    [self.defaultViewController.historyView cover];
    [((WEAppDelegate *)[UIApplication sharedApplication].delegate) hideTabbar];
    [textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self updateSearchResultViewForSearchKeyword:self.searchBarTextField.text searchCategory:0];
    [self.searchBarTextField endEditing:YES];
    return YES;
}

- (IBAction)didClickCancelButton:(id)sender
{
    [self clearSearchResultView];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.textFieldContainerView resetWidth:kSearchbarNotEditingWidth];
        [self.cancelButton resetOriginX:self.searchBarContainerView.frame.size.width];
    } completion:^(BOOL finished) {
    }];
    self.searchBarTextField.text = @"";
    [self.searchBarTextField endEditing:YES];
    [self.defaultViewController.historyView uncover];
    [((WEAppDelegate *)[UIApplication sharedApplication].delegate) showTabbar];
}

#pragma mark - WTSearchResultTableViewControllerDelegate
- (void)wantToPushViewController:(UIViewController *)vc {
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WTSearchDefaultViewControllerDelegate
- (void)didClickSearchHistoryItem:(NSString *)keyword
{
    self.searchBarTextField.text = keyword;
    [self updateSearchResultViewForSearchKeyword:keyword searchCategory:0];
}

- (void)backToNoEditingState
{
    [self didClickCancelButton:nil];
}

@end
