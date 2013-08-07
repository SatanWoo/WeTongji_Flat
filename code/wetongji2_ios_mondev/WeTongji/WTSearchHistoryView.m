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
#import "WTSearchViewController.h"

#define CLEAR_HISTORY_CELL_ROW  ([[NSUserDefaults standardUserDefaults] getSearchHistoryArray].count)

@interface WTSearchHistoryView ()

@end

@implementation WTSearchHistoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (WTSearchHistoryView *)createSearchHistoryView {
    WTSearchHistoryView * result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTSearchHistoryView" owner:nil options:nil];
    
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTSearchHistoryView class]]) {
            result = (WTSearchHistoryView *)view;
            break;
        }
    }
    
    [result configureView];
    
    return result;
}

- (void)configureView {
    WTSearchHistoryTableViewHeaderView *headerView = [WTSearchHistoryTableViewHeaderView createHeaderView];
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != CLEAR_HISTORY_CELL_ROW) {
        NSDictionary *searchHistoryInfoDict = [[NSUserDefaults standardUserDefaults] getSearchHistoryArray][indexPath.row];
        [[UIApplication sharedApplication].searchViewController showSearchResultWithSearchKeyword:[NSUserDefaults getSearchHistoryKeyword:searchHistoryInfoDict] searchCategory:[NSUserDefaults getSearchHistoryCategory:searchHistoryInfoDict]];
    } else {
        [[NSUserDefaults standardUserDefaults] clearAllSearchHistoryItems];
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
    
    
    if (indexPath.row != CLEAR_HISTORY_CELL_ROW) {
        
        NSDictionary *searchHistoryInfoDict = [[NSUserDefaults standardUserDefaults] getSearchHistoryArray][indexPath.row];
    
        [searchHistoryCell configureCellWithIndexPath:indexPath
                                        searchKeyword:[NSUserDefaults getSearchHistoryKeyword:searchHistoryInfoDict]
                                       searchCategory:[NSUserDefaults getSearchHistoryCategory:searchHistoryInfoDict]];
    } else {    
        [searchHistoryCell configureCellWithIndexPath:indexPath
                                        searchKeyword:nil
                                       searchCategory:0];
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
