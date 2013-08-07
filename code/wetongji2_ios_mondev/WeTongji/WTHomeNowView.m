//
//  WTHomeNowView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTHomeNowView.h"
#import "OHAttributedLabel.h"
#import "Event+Addition.h"
#import "NSString+WTAddition.h"
#import "NSAttributedString+WTAddition.h"
#import "Object+Addition.h"

@interface WTHomeNowContainerView ()

@property (nonatomic, strong) NSMutableArray *itemViewArray;
@property (nonatomic, strong) NSMutableArray *eventArray;

@end

@implementation WTHomeNowContainerView

+ (WTHomeNowContainerView *)createHomeNowContainerViewWithDelegate:(id<WTHomeNowContainerViewDelegate>)delegate {
    WTHomeNowContainerView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTHomeNowView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTHomeNowContainerView class]]) {
            result = (WTHomeNowContainerView *)view;
            result.itemViewArray = [NSMutableArray arrayWithCapacity:2];
            result.eventArray = [NSMutableArray arrayWithCapacity:2];
            result.scrollView.contentSize = CGSizeMake(640.0f, result.scrollView.frame.size.height);
            
            result.delegate = delegate;
            break;
        }
    }
    return result;
}

- (void)clearItemViewsAndEvents {
    for (UIView *view in self.itemViewArray) {
        [view removeFromSuperview];
    }
    [self.itemViewArray removeAllObjects];
    
    for (Event *event in self.eventArray) {
        [event setObjectFreeFromHolder:[self class]];
    }
    [self.eventArray removeAllObjects];
}

- (void)configureNowContainerViewWithEvents:(NSArray *)events {
    [self clearItemViewsAndEvents];
    
    if (!events) {
        WTHomeNowEmptyItemView *emptyItemView = [WTHomeNowEmptyItemView createNowEmptyItemView];
        [self.itemViewArray addObject:emptyItemView];
        [self.scrollView addSubview:emptyItemView];
        
        self.switchContainerView.alpha = 0;
        return;
    } else if (events.count == 1) {
        self.scrollView.contentOffset = CGPointZero;
        self.switchContainerView.alpha = 0.2f;
        self.switchContainerView.userInteractionEnabled = NO;
        
        self.switchMoreReverseIndicator.alpha = 0;
        self.switchMoreIndicator.alpha = 1;
    } else {
        self.switchContainerView.alpha = 1.0f;
        self.switchContainerView.userInteractionEnabled = YES;
    }
    
    NSUInteger eventIndex = 0;
    for (Event *event in events) {
        WTHomeNowItemView *itemView = [WTHomeNowItemView createNowItemViewWithEvent:event];
        [self.itemViewArray addObject:itemView];
        itemView.nowOrLaterLabel.text = (eventIndex == 0) ? NSLocalizedString(@"Now", nil) : NSLocalizedString(@"Later", nil);
        
        [itemView resetOriginX:320.0f * eventIndex];
        [self.scrollView insertSubview:itemView belowSubview:self.switchContainerView];
        
        itemView.bgButton.tag = eventIndex;
        [itemView.bgButton addTarget:self action:@selector(didClickItemView:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.eventArray addObject:event];
        [event setObjectHeldByHolder:[self class]];
        
        eventIndex++;
    }
}

#pragma mark - Animations

- (void)showSecondItemAnimation {
    self.userInteractionEnabled = NO;
    WTHomeNowItemView *firstView = self.itemViewArray[0];
    WTHomeNowItemView *secondView = self.itemViewArray[1];
    firstView.shadowCoverView.alpha = 0;
    secondView.shadowCoverView.alpha = 1;
    [UIView animateWithDuration:0.5f animations:^{
        self.switchMoreIndicator.alpha = 0;
        self.switchMoreReverseIndicator.alpha = 1;
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width - self.switchContainerView.frame.size
                                                    .width, 0);
        
        
        firstView.shadowCoverView.alpha = 1;
        secondView.shadowCoverView.alpha = 0;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

- (void)showFirstItemAnimation {
    self.userInteractionEnabled = NO;
    WTHomeNowItemView *firstView = self.itemViewArray[0];
    WTHomeNowItemView *secondView = self.itemViewArray[1];
    firstView.shadowCoverView.alpha = 1;
    secondView.shadowCoverView.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        self.switchMoreIndicator.alpha = 1;
        self.switchMoreReverseIndicator.alpha = 0;
        self.scrollView.contentOffset = CGPointZero;
        
        firstView.shadowCoverView.alpha = 0;
        secondView.shadowCoverView.alpha = 1;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

#pragma mark - Actions

- (IBAction)didClickSwitchItemButton:(UIButton *)sender {
    if (self.scrollView.contentOffset.x == 0) {
        [self showSecondItemAnimation];
    } else {
        [self showFirstItemAnimation];
    }
}

- (void)didClickItemView:(UIButton *)sender {
    [self.delegate homeNowContainerViewDidSelectEvent:self.eventArray[sender.tag]];
}

@end

@implementation WTHomeNowItemView

+ (WTHomeNowItemView *)createNowItemViewWithEvent:(Event *)event {
    WTHomeNowItemView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTHomeNowView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTHomeNowItemView class]]) {
            result = (WTHomeNowItemView *)view;
            break;
        }
    }
    [result configureNowItemViewWithEvent:event];
    return result;
}

- (void)configureNowItemViewWithEvent:(Event *)event {
    [self configureFriendCountLabel:event.friendsCount];
    [self configureEventTitle:event.what place:event.where time:event.yearMonthDayBeginToEndTimeString];
}

- (void)configureEventTitle:(NSString *)title
                      place:(NSString *)place
                       time:(NSString *)time {
    self.titleLabel.text = title;
    self.placeLabel.text = place;
    self.timeLabel.text = time;
}

- (void)configureFriendCountLabel:(NSNumber *)count {
    
    self.friendCountLabel.automaticallyAddLinksForType = 0;
    
    self.friendCountLabel.attributedText = [NSAttributedString friendCountStringConvertFromCountNumber:count font:self.friendCountLabel.font textColor:self.friendCountLabel.textColor];
}

@end

@implementation WTHomeNowEmptyItemView

+ (WTHomeNowEmptyItemView *)createNowEmptyItemView {
    WTHomeNowEmptyItemView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTHomeNowView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTHomeNowEmptyItemView class]]) {
            result = (WTHomeNowEmptyItemView *)view;
            break;
        }
    }
    result.emptyLabel.text = NSLocalizedString(@"No Schedule today", nil);
    return result;
}

@end
