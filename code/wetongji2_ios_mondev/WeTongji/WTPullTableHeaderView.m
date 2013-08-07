//
//  WTPullTableHeaderView.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-12.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTPullTableHeaderView.h"
#define kPullOffsetToRefresh 80

@interface WTPullTableHeaderView()

- (void)changeStateToLoad:(UIScrollView *)scollView;;
- (void)changeStateToNormal:(UIScrollView *)scrollView;
@end

@implementation WTPullTableHeaderView

@synthesize updatedTimeLabel = _updatedTimeLabel;
@synthesize informationLabel = _informationLabel;
@synthesize indicatorView = _indicatorView;
@synthesize state = _state;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.state = WTPullTableHeaderViewStateNormal;
    }
    return self;
}

#pragma mark - Override Setter

- (void)setState:(WTPullTableHeaderViewState)state
{
    if (state == WTPullTableHeaderViewStatePull) {
        self.informationLabel.text = @"释放刷新，看看以前的日程";
    } else if (state == WTPullTableHeaderViewStateNormal) {
        self.informationLabel.text = @"下拉可以看到以前的日程哦";
        [self refreshUpdatedTime];
    } else {
        self.informationLabel.text = @"正在加载数据，请稍后";
    }
}

#pragma mark - Private Method

- (void)changeStateToLoad:(UIScrollView *)scrollView;
{
    [UIView animateWithDuration:0.25f animations:^{
        scrollView.contentInset = UIEdgeInsetsMake(kPullOffsetToRefresh, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [self.indicatorView startAnimating];
        self.state = WTPullTableHeaderViewStateLoad;
        [self.delegate pullToLoadData];
    }];
}

- (void)changeStateToNormal:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.25f animations:^{
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [self.indicatorView stopAnimating];
        self.state = WTPullTableHeaderViewStateNormal;
    }];
}

- (void)refreshUpdatedTime
{
    NSDateFormatter *formatter = nil;
    
    if ([self.delegate respondsToSelector:@selector(updateDateFormat)] ) {
       formatter = [self.delegate updateDateFormat];
    } else {
        formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
    }
    
    self.updatedTimeLabel.text = [formatter stringFromDate:[NSDate date]];
}

#pragma mark - Public 

- (void)pullTableHeaderViewDidScroll:(UIScrollView *)scrollView
{
    if (self.state == WTPullTableHeaderViewStateLoad) {
        return ;
    } else if (scrollView.isDragging) {
        if (scrollView.contentOffset.y <= - kPullOffsetToRefresh) {
            self.state = WTPullTableHeaderViewStatePull;
        } else if (scrollView.contentOffset.y > -kPullOffsetToRefresh && scrollView.contentOffset.y <= 0) {
            self.state = WTPullTableHeaderViewStateNormal;
        }
    }
}

- (void)pullTableHeaderViewDidEndDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= - kPullOffsetToRefresh && self.state != WTPullTableHeaderViewStateLoad) {
        [self changeStateToLoad:scrollView];
    } 
}

- (void)pullTableHeaderViewDidFinishingLoading:(UIScrollView *)scrollView
{
    NSLog(@"Did Finish Loading");
    [self changeStateToNormal:scrollView];
}

@end
