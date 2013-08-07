//
//  WTSearchViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-11-13.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTSearchViewController.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "WTResourceFactory.h"
#import "User+Addition.h"
#import "WTSearchHintView.h"
#import "WTSearchResultTableViewController.h"
#import "WTSearchDefaultViewController.h"
#import <WeTongjiSDK/NSUserDefaults+WTSDKAddition.h>

@interface WTSearchViewController () <UITableViewDelegate, WTSearchResultTableViewControllerDelegate>

@property (nonatomic, weak) UIButton *customSearchBarCancelButton;

@property (nonatomic, strong) WTSearchHintView *searchHintView;

@property (nonatomic, assign) BOOL shouldSearchBarBecomeFirstResponder;

@property (nonatomic, strong) WTSearchResultTableViewController *resultViewController;

@property (nonatomic, strong) WTSearchDefaultViewController *defaultViewController;

@end

@implementation WTSearchViewController

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
    [self configureDefaultView];
    [self configureSearchHintView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.resultViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.resultViewController viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillDismissNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.resultViewController viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showSearchResultWithSearchKeyword:(NSString *)keyword
                           searchCategory:(NSInteger)category {
    [self showSearchBarCancelButton:YES];
    [self showHintView:NO];
    [self showSearchResultView:YES];
    
    if (self.defaultViewController.shadowCoverView.alpha == 0)
        [self.defaultViewController.shadowCoverView fadeIn];
    
    self.searchBar.text = keyword;
    [self updateSearchResultViewForSearchKeyword:keyword searchCategory:category];
}

#pragma mark - Keyboard notification

- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGFloat keyboardHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self configureSearchHintViewSizeWithKeyboardHeight:keyboardHeight];
}

- (void)handleKeyboardWillDismissNotification:(NSNotification *)notification {
    [self configureSearchHintViewSizeWithKeyboardHeight:0];
}

#pragma mark - UI methods

- (void)disableNotificationBarButton {
    self.notificationButton.customView.alpha = 0.5f;
    self.notificationButton.enabled = NO;
}

- (void)enableNotificationBarButton {
    self.notificationButton.customView.alpha = 1.0f;
    self.notificationButton.enabled = YES;
}

- (void)configureSearchHintViewSizeWithKeyboardHeight:(CGFloat)keyboardHeight {
    CGFloat visibleScreenHeight = [UIScreen mainScreen].bounds.size.height - 64.0f - keyboardHeight;
    visibleScreenHeight = visibleScreenHeight > self.view.frame.size.height ? self.view.frame.size.height : visibleScreenHeight;
    [self.searchHintView.tableView resetHeight:visibleScreenHeight];
}

- (void)configureSearchHintView {
    self.searchHintView = [WTSearchHintView createSearchHintView];
    self.searchHintView.hidden = YES;
    self.searchHintView.tableView.delegate = self;
    [self.searchHintView resetHeight:self.view.frame.size.height];
    [self.view addSubview:self.searchHintView];
}

- (void)configureDefaultView {
    self.defaultViewController = [[WTSearchDefaultViewController alloc] init];
    [self.defaultViewController.view resetHeight:self.view.frame.size.height];
    [self.view addSubview:self.defaultViewController.view];
}

- (void)configureSearchBarBgWithControlState:(UIControlState)state {
    if (state == UIControlStateSelected) {
        UIImage *selectBgImage = [[UIImage imageNamed:@"WTSearchBarSelectBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
        [self.searchBar setSearchFieldBackgroundImage:selectBgImage forState:UIControlStateNormal];
        
        UIImage *selectSearchIcon = [UIImage imageNamed:@"WTSearchBarSelectSearchIcon"];
        [self.searchBar setImage:selectSearchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        
    } else if (state == UIControlStateNormal) {
        UIImage *normalBgImage = [[UIImage imageNamed:@"WTSearchBarNormalBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
        [self.searchBar setSearchFieldBackgroundImage:normalBgImage forState:UIControlStateNormal];
        
        UIImage *nornalSearchIcon = [UIImage imageNamed:@"WTSearchBarNormalSearchIcon"];
        [self.searchBar setImage:nornalSearchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    }
}

- (void)configureSearchBarTextFieldClearButtonWithCancelButtonStatus:(BOOL)showingCancelButton {
    for (UIView *subview in self.searchBar.subviews) {
        if ([subview conformsToProtocol:@protocol(UITextInputTraits)]) {
            UITextField *textFielt = (UITextField *)subview;
            if (showingCancelButton) {
                [textFielt setClearButtonMode:UITextFieldViewModeAlways];
            } else {
                [textFielt setClearButtonMode:UITextFieldViewModeWhileEditing];
            }
        }
    }
}

- (void)configureNavigationBar {
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 1.0f, 270.0f, 44.0f)];
    searchBar.delegate = self;
    self.searchBar = searchBar;
    
    [searchBar.subviews[0] removeFromSuperview];
    [self addCustomCancelButtonToSearchBar];
    [self showCustomSearchBarCancelButton:NO animated:NO];
    [self configureSearchBarBgWithControlState:UIControlStateNormal];
    
    UIView *searchBarContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270.0f, 44.0f)];
    searchBarContainerView.backgroundColor = [UIColor clearColor];
    [searchBarContainerView addSubview:searchBar];
    
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBarContainerView];
    self.navigationItem.rightBarButtonItem = searchBarButtonItem;
}

#define CUSTOM_SEARCH_BAR_CANCEL_BUTTON_TAG 10000

- (void)addCustomCancelButtonToSearchBar {
    UIButton *customSearchBarCancelButton = [WTResourceFactory createNormalButtonWithText:NSLocalizedString(@"Cancel", nil)];
    [customSearchBarCancelButton resetOriginY:1.0f];
    [customSearchBarCancelButton resetOriginX:self.searchBar.frame.size.width - customSearchBarCancelButton.frame.size.width];
    customSearchBarCancelButton.tag = CUSTOM_SEARCH_BAR_CANCEL_BUTTON_TAG;
    [customSearchBarCancelButton addTarget:self action:@selector(didClickCustomSearchBarCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBar addSubview:customSearchBarCancelButton];
    self.customSearchBarCancelButton = customSearchBarCancelButton;
}

- (void)hideOriginalSearchBarCancelButton {
    for (UIView *subView in self.searchBar.subviews) {
        if([subView isKindOfClass:[UIButton class]] && subView.tag != CUSTOM_SEARCH_BAR_CANCEL_BUTTON_TAG) {
            subView.hidden = YES;
        }
    }
}

- (void)showCustomSearchBarCancelButton:(BOOL)show animated:(BOOL)animated {
    [self hideOriginalSearchBarCancelButton];
    if (animated) {
        CGFloat customCancelButtonOriginX = self.customSearchBarCancelButton.frame.origin.x;
        CGFloat customCacnelButtonWidth = self.customSearchBarCancelButton.frame.size.width;
        self.searchBar.userInteractionEnabled = NO;
        
        if (show) {
            self.customSearchBarCancelButton.alpha = 0;
            [self.customSearchBarCancelButton resetOriginX:customCancelButtonOriginX + customCacnelButtonWidth];
        } else {
            self.customSearchBarCancelButton.alpha = 1;
        }
        
        [UIView animateWithDuration:0.25f animations:^{
            if (show) {
                [self.customSearchBarCancelButton resetOriginX:customCancelButtonOriginX];
                self.customSearchBarCancelButton.alpha = 1;
            } else {
                [self.customSearchBarCancelButton resetOriginX:customCancelButtonOriginX + customCacnelButtonWidth];
                self.customSearchBarCancelButton.alpha = 0;
            }
        } completion:^(BOOL finished) {
            [self.customSearchBarCancelButton resetOriginX:customCancelButtonOriginX];
            self.searchBar.userInteractionEnabled = YES;
        }];
    } else {
        if (show) {
            self.customSearchBarCancelButton.alpha = 1;
        } else {
            self.customSearchBarCancelButton.alpha = 0;
        }
    }
}

- (void)showHintView:(BOOL)show {
    self.searchHintView.hidden = !show;
}

- (void)showSearchResultView:(BOOL)show {
    self.resultViewController.view.hidden = !show;
}

- (void)updateSearchResultViewForSearchKeyword:(NSString *)keyword searchCategory:(NSInteger)category {
    [self.resultViewController.view removeFromSuperview];    
    WTSearchResultTableViewController *vc = [WTSearchResultTableViewController createViewControllerWithSearchKeyword:keyword searchCategory:category delegate:self];
    self.resultViewController = vc;
    [vc.view resetHeight:self.view.frame.size.height];
    // 刷新resultViewController中tableView的高度。
    [self.resultViewController viewWillAppear:NO];
    [self.view insertSubview:vc.view aboveSubview:self.defaultViewController.view];
    
    [self.defaultViewController.historyView.tableView reloadData];
}

- (void)showSearchBarCancelButton:(BOOL)show {
    if (self.searchBar.showsCancelButton == show)
        return;
    
    [self configureSearchBarTextFieldClearButtonWithCancelButtonStatus:YES];
    
    [self configureSearchBarBgWithControlState:show ? UIControlStateSelected : UIControlStateNormal];
    [self.searchBar setShowsCancelButton:show animated:YES];
    [self showCustomSearchBarCancelButton:show animated:YES];
}

#pragma mark - WTRootNavigationControllerDelegate

- (UIScrollView *)sourceScrollView {
    if (!self.resultViewController.view.hidden)
        return self.resultViewController.tableView;
    else
        return self.defaultViewController.historyView.tableView;
}

- (void)didHideInnderModalViewController {
    [super didHideInnderModalViewController];
    
    if (self.shouldSearchBarBecomeFirstResponder) {
        self.shouldSearchBarBecomeFirstResponder = NO;
        [self.searchBar becomeFirstResponder];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchHintView.tableView) {
        [self updateSearchResultViewForSearchKeyword:self.searchBar.text searchCategory:indexPath.row];
        [self.searchBar resignFirstResponder];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Actions

- (void)didClickCustomSearchBarCancelButton:(UIButton *)sender {
    [self showSearchBarCancelButton:NO];
    [self.searchBar resignFirstResponder];
    [self showHintView:NO];
    
    self.searchBar.text = @"";
    self.searchHintView.searchKeyword = @"";
    
    [self configureSearchBarTextFieldClearButtonWithCancelButtonStatus:NO];
    
    [self showSearchResultView:NO];
    
    if (self.defaultViewController.shadowCoverView.alpha == 1)
        [self.defaultViewController.shadowCoverView fadeOut];
}

- (void)didClickNotificationButton:(WTNotificationBarButton *)sender {
    if (!sender.selected) {
        if (self.searchBar.isFirstResponder) {
            self.shouldSearchBarBecomeFirstResponder = YES;
            [self.searchBar resignFirstResponder];
        }
    }
    [super didClickNotificationButton:sender];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    WTLOG(@"searchBarTextDidBeginEditing");
    [self showSearchBarCancelButton:YES];
    [self showHintView:YES];
    [self showSearchResultView:NO];
    
    if (self.defaultViewController.shadowCoverView.alpha == 0)
        [self.defaultViewController.shadowCoverView fadeIn];
    
    self.searchHintView.searchKeyword = searchBar.text;
    
    [self disableNotificationBarButton];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    WTLOG(@"searchBarTextDidEndEditing");
    [self showHintView:NO];
    [self showSearchResultView:YES];
    
    [self enableNotificationBarButton];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchHintView.searchKeyword = searchText;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    // 彩蛋
    // TODO: 将后面的代码移到专门的彩蛋模块去
    
    if ([searchBar.text isEqualToString:@"set use test server"]) {
        [NSUserDefaults setUseTestServer:YES];
        [((UIAlertView *)[[UIAlertView alloc] initWithTitle:@"注意" message:@"已切换至测试服务器" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil]) show];
    } else if ([searchBar.text isEqualToString:@"set use produce server"]) {
        [NSUserDefaults setUseTestServer:NO];
        [((UIAlertView *)[[UIAlertView alloc] initWithTitle:@"注意" message:@"已切换至生产服务器" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil]) show];
    } else {
        [searchBar resignFirstResponder];
        [self updateSearchResultViewForSearchKeyword:self.searchBar.text searchCategory:0];
    }
    
}

#pragma mark - WTSearchResultTableViewControllerDelegate

- (void)wantToPushViewController:(UIViewController *)vc {
    [self.navigationController pushViewController:vc animated:YES];
}

@end
