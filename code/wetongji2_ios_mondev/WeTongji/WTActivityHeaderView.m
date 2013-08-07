//
//  WTActivityHeaderView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-25.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTActivityHeaderView.h"
#import "Activity+Addition.h"
#import "WTResourceFactory.h"
#import "NSString+WTAddition.h"

@interface WTActivityHeaderView ()

@property (nonatomic, weak) IBOutlet UILabel *activityTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *activityTimeLabel;
@property (nonatomic, weak) IBOutlet UIButton *activityLocationButton;
@property (nonatomic, weak) IBOutlet UIImageView *activityLocationDisclosureImageView;

@property (nonatomic, weak) Activity *activity;

@end

@implementation WTActivityHeaderView

+ (WTActivityHeaderView *)createHeaderViewWithActivity:(Activity *)activity {
    WTActivityHeaderView *result = [[NSBundle mainBundle] loadNibNamed:@"WTActivityHeaderView" owner:nil options:nil].lastObject;
    
    result.activity = activity;
    
    result.activityOutdated = ([activity.endTime compare:[NSDate date]] == NSOrderedAscending);
    
    [result configureView];
    
    return result;
}

#pragma mark - UI methods

- (void)configureView {
    [self configureBackgroundColor];
    [self configureActivityLocationButton];
    [self configureBottomButtons];
    [self configureActivityTimeLabel];
    [self configureActivityTitleLabelAndCalculateHeight];
}

- (void)configureActivityLocationButton {
    [self.activityLocationButton setTitle:self.activity.where forState:UIControlStateNormal];
    CGFloat locationButtonHeight = self.activityLocationButton.frame.size.height;
    CGFloat locationButtonCenterY = self.activityLocationButton.center.y;
    CGFloat locationButtonRightBoundX = self.activityLocationButton.frame.origin.x + self.activityLocationButton.frame.size
    .width;
    [self.activityLocationButton sizeToFit];
    
    CGFloat maxLocationButtonWidth = 282.0f;
    if (self.activityLocationButton.frame.size.width > maxLocationButtonWidth) {
        [self.activityLocationButton resetWidth:maxLocationButtonWidth];
    }
    
    [self.activityLocationButton resetHeight:locationButtonHeight];
    [self.activityLocationButton resetCenterY:locationButtonCenterY];
    [self.activityLocationButton resetOriginX:locationButtonRightBoundX - self.activityLocationButton.frame.size.width];
}

#define MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH    85.0f
#define MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_ORIGIN_Y 83.0f

- (void)configureInviteButton {
    [self.inviteButton removeFromSuperview];
    self.inviteButton = [WTResourceFactory createFocusButtonWithText:NSLocalizedString(@"Invite", nil)];
    
    if (self.inviteButton.frame.size.width < MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH)
        [self.inviteButton resetWidth:MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH];
    
    [self.inviteButton resetOrigin:CGPointMake(9.0, MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_ORIGIN_Y)];
    self.inviteButton.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:self.inviteButton];
    
    if (!self.activity.scheduledByCurrentUser) {
        self.inviteButton.alpha = 0;
    }
}

- (void)configureParticipateButton {
    
    if (!self.activityOutdated) {
        self.participateButton = [WTResourceFactory createNormalButtonWithText:@""];
        [self configureParticipateButtonStatus:self.activity.scheduledByCurrentUser];
    } else {
        self.participateButton = [WTResourceFactory createDisableButtonWithText:self.activity.scheduledByCurrentUser ? NSLocalizedString(@"Participated", nil) : NSLocalizedString(@"Outdated", nil)];
    }
    
    if (self.participateButton.frame.size.width < MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH)
        [self.participateButton resetWidth:MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH];
    
    [self.participateButton resetOrigin:CGPointMake(311.0f - self.participateButton.frame.size.width, MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_ORIGIN_Y)];
    self.participateButton.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:self.participateButton];
}

- (void)configureFriendCountButton {
    NSString *friendCountString = [NSString friendCountStringConvertFromCountNumber:self.activity.friendsCount];
    self.friendCountButton = [WTResourceFactory createNormalButtonWithText:friendCountString];
    if (self.friendCountButton.frame.size.width < MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH)
        [self.friendCountButton resetWidth:MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH];
    
    [self.friendCountButton resetOrigin:CGPointMake(self.participateButton.frame.origin.x - 8 - self.friendCountButton.frame.size.width, MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_ORIGIN_Y)];
    self.friendCountButton.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:self.friendCountButton];
}

- (void)configureActivityTimeLabel {
    self.activityTimeLabel.text = self.activity.yearMonthDayBeginToEndTimeString;
}

#define BRIEF_DESCRIPTION_VIEW_BOTTOM_BUTTONS_HEIGHT    40.0f

- (void)configureActivityTitleLabelAndCalculateHeight {
    self.activityTitleLabel.text = self.activity.what;
    
    CGFloat titleLabelOriginalHeight = self.activityTitleLabel.frame.size.height;
    [self.activityTitleLabel sizeToFit];
    [self resetHeight:self.frame.size.height + self.activityTitleLabel.frame.size.height - titleLabelOriginalHeight];
}

- (void)configureBackgroundColor {
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTGrayPanel"]];
}

- (void)configureBottomButtons {
    [self configureParticipateButton];
    [self configureFriendCountButton];
    if (!self.activityOutdated) {
        [self configureInviteButton];
    }
}

#pragma mark - Configure button status methods

- (void)configureParticipateButtonStatus:(BOOL)participated {
    self.participateButton.selected = !participated;
    if (participated) {
        [self.participateButton setTitle:NSLocalizedString(@"Participated", nil) forState:UIControlStateNormal];
    } else {
        [self.participateButton setTitle:NSLocalizedString(@"Participate", nil) forState:UIControlStateNormal];
    }
}

@end
