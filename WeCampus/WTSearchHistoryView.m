//
//  WTSearchHistoryView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-12.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTSearchHistoryView.h"
#import "NSUserDefaults+WTAddition.h"
#import "WTSearchHistoryCell.h"
#import "UIApplication+WTAddition.h"

#define CLEAR_HISTORY_CELL_ROW  ([[NSUserDefaults standardUserDefaults] getSearchHistoryArray].count)

@interface WTSearchHistoryView ()

@end

@implementation WTSearchHistoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (WTSearchHistoryView *)createSearchHistoryView {
    WTSearchHistoryView * result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTSearchHistoryView" owner:nil options:nil];
    
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTSearchHistoryView class]]) {
            result = (WTSearchHistoryView *)view;
            result.maskView.hidden = YES;
            result.scrollView.hidden = YES;
            result.scrollView.contentSize = CGSizeMake(result.scrollView.frame.size.width, result.scrollView.frame.size.height + 1);
            
            [result configureScrollView];
            break;
        }
    }
    
    return result;
}

- (IBAction)backToNoEditingState
{
    if (self.delegate) {
        [self.delegate didClickHistoryMaskView];
    }
}

- (void)cover{
    self.maskView.hidden = NO;
    self.returnButton.hidden = NO;
}

- (void)uncover
{
    self.maskView.hidden = YES;
    self.returnButton.hidden = YES;
}

- (void)configureScrollView
{
    if ([[NSUserDefaults standardUserDefaults] getSearchHistoryArray].count) {
        self.scrollView.hidden = YES;
        self.tableView.hidden = NO;
    } else {
        self.scrollView.hidden = NO;
        self.tableView.hidden = YES;
    }
}

- (void)reload
{
    [self.tableView reloadData];
    [self configureScrollView];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != CLEAR_HISTORY_CELL_ROW) {
        NSDictionary *searchHistoryInfoDict = [[NSUserDefaults standardUserDefaults] getSearchHistoryArray][indexPath.row];
        NSString *keyword = [NSUserDefaults getSearchHistoryKeyword:searchHistoryInfoDict];
        if (self.delegate) {
            [self.delegate didClickHistoryItem:keyword];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] clearAllSearchHistoryItems];
        [self configureScrollView];
        [tableView reloadData];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[NSUserDefaults standardUserDefaults] getSearchHistoryArray].count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"WTSearchHistoryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = nib.lastObject;
    }
    
    WTSearchHistoryCell *searchHistoryCell = (WTSearchHistoryCell *)cell;
    
    if (indexPath.row < CLEAR_HISTORY_CELL_ROW) {
        
        NSDictionary *searchHistoryInfoDict = [[NSUserDefaults standardUserDefaults] getSearchHistoryArray][indexPath.row];
        [searchHistoryCell configureCellWithSearchKeyword:[NSUserDefaults getSearchHistoryKeyword:searchHistoryInfoDict] searchCategory:[NSUserDefaults getSearchHistoryCategory:searchHistoryInfoDict]];
        
    } else {    
        [searchHistoryCell configureCellWithSearchKeyword:nil searchCategory:0];
    }
    return cell;
}

@end

@implementation WTSearchHistoryTableViewHeaderView

+ (WTSearchHistoryTableViewHeaderView *)createHeaderView {
    WTSearchHistoryTableViewHeaderView * result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTSearchHistoryView" owner:nil options:nil];
    
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTSearchHistoryTableViewHeaderView class]]) {
            result = (WTSearchHistoryTableViewHeaderView *)view;
            break;
        }
    }
    
    [result configureView];
    
    return result;
}

- (void)configureView {
    self.searchHistoryDisplayLabel.text = NSLocalizedString(@"Search History", nil);
}

@end
