//
//  WTTableView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-31.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTTableView.h"
#import "WTResourceFactory.h"

@interface WTTableView ()

@property (nonatomic, strong) UIView *topPlaceholderView;

@end

@implementation WTTableView

- (void)didMoveToSuperview {
    if (!self.topPlaceholderView.superview) {
        [self addSubview:self.topPlaceholderView];
        [self sendSubviewToBack:self.topPlaceholderView];
    }
}

#pragma mark - Properties

- (UIView *)topPlaceholderView {
    if (!_topPlaceholderView) {
        _topPlaceholderView = [WTResourceFactory createPlaceholderViewWithScrollView:self];
    }
    return _topPlaceholderView;
}

@end
