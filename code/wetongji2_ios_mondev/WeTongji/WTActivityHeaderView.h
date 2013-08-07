//
//  WTActivityHeaderView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-25.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;

#define HEADER_VIEW_BOTTOM_INDENT   50.0f

@interface WTActivityHeaderView : UIView

@property (nonatomic, strong) UIButton *friendCountButton;

@property (nonatomic, strong) UIButton *participateButton;

@property (nonatomic, strong) UIButton *inviteButton;

@property (nonatomic, assign) BOOL activityOutdated;

+ (WTActivityHeaderView *)createHeaderViewWithActivity:(Activity *)activity;

- (void)configureParticipateButtonStatus:(BOOL)participated;

- (void)configureInviteButton;

@end
