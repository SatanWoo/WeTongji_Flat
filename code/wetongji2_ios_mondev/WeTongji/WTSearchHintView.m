//
//  WTSearchHintView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTSearchHintView.h"
#import "WTSearchHintCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation WTSearchHintView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (WTSearchHintView *)createSearchHintView {
    WTSearchHintView *result = [[NSBundle mainBundle] loadNibNamed:@"WTSearchHintView" owner:nil options:nil].lastObject;
    // result.layer.borderColor = [UIColor blackColor].CGColor;
    // result.layer.borderWidth = 1.0f;
    return result;
}

#pragma mark - Properties

- (void)setSearchKeyword:(NSString *)searchKeyword {
    if (![searchKeyword isEqualToString:_searchKeyword]) {
        _searchKeyword = [searchKeyword copy];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchKeyword && ![self.searchKeyword isEqualToString:@""])
        return 6;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"WTSearchHintCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = nib.lastObject;
    }
    
    WTSearchHintCell *searchHintCell = (WTSearchHintCell *)cell;
    [searchHintCell configureCellWithIndexPath:indexPath searchKeyword:self.searchKeyword];
    return cell;
}

@end
