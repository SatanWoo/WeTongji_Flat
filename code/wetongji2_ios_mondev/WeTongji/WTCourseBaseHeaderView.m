//
//  WTCourseBaseHeaderView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCourseBaseHeaderView.h"
#import "WTResourceFactory.h"
#import "Course+Addition.h"
#import "NSString+WTAddition.h"
#import "WTNowConfigLoader.h"

@interface WTCourseBaseHeaderView ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation WTCourseBaseHeaderView

#pragma mark - Methods to overwrite

- (Course *)targetCourse {
    return nil;
}

- (void)configureView {
    
    self.courseOutdated = [[WTNowConfigLoader sharedLoader] isCourseOutdated:[self targetCourse]];
    
    [self configureBackgroundColor];
    [self configureBottomButtons];
    [self configureTitleLabelAndCalculateHeight];
}

#pragma mark - UI methods

#define BRIEF_DESCRIPTION_VIEW_BOTTOM_BUTTONS_HEIGHT    40.0f

- (void)configureTitleLabelAndCalculateHeight {
    self.titleLabel.text = [self targetCourse].courseName;
    
    CGFloat titleLabelOriginalHeight = self.titleLabel.frame.size.height;
    [self.titleLabel sizeToFit];
    [self resetHeight:self.frame.size.height + self.titleLabel.frame.size.height - titleLabelOriginalHeight];
}

- (void)configureBackgroundColor {
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTGrayPanel"]];
}

- (void)configureBottomButtons {
    [self configureParticipateButton];
    [self configureFriendCountButton];
    if (!self.courseOutdated)
        [self configureInviteButton];
}

#define MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH    85.0f
#define MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_ORIGIN_Y 83.0f

- (void)configureParticipateButton {
    Course *course = [self targetCourse];
    if (!self.courseOutdated) {
        if (!course.isAudit.boolValue) {
            self.participateButton = [WTResourceFactory createDisableButtonWithText:NSLocalizedString(@"Registered", nil)];
        } else {
            self.participateButton = [WTResourceFactory createNormalButtonWithText:@""];
            [self configureParticipateButtonStatus:course.registeredByCurrentUser];
        }
    } else {
        NSString *participateButtonText = nil;
        if (course.registeredByCurrentUser) {
            if (!course.isAudit.boolValue) {
                participateButtonText = NSLocalizedString(@"Registered", nil);
            } else {
                participateButtonText = NSLocalizedString(@"Audited", nil);
            }
        } else {
            participateButtonText = NSLocalizedString(@"Outdated", nil);
        }
        self.participateButton = [WTResourceFactory createDisableButtonWithText:participateButtonText];
    }
    
    if (self.participateButton.frame.size.width < MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH)
        [self.participateButton resetWidth:MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH];
    
    [self.participateButton resetOrigin:CGPointMake(311.0f - self.participateButton.frame.size.width, MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_ORIGIN_Y)];
    self.participateButton.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:self.participateButton];
}

- (void)configureInviteButton {
    [self.inviteButton removeFromSuperview];
    self.inviteButton = [WTResourceFactory createFocusButtonWithText:NSLocalizedString(@"Invite", nil)];
    
    if (self.inviteButton.frame.size.width < MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH)
        [self.inviteButton resetWidth:MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH];
    
    [self.inviteButton resetOrigin:CGPointMake(9.0, MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_ORIGIN_Y)];
    self.inviteButton.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:self.inviteButton];
}

- (void)configureFriendCountButton {
    Course *course = [self targetCourse];
    NSString *friendCountString = [NSString friendCountStringConvertFromCountNumber:course.friendsCount];
    self.friendCountButton = [WTResourceFactory createNormalButtonWithText:friendCountString];
    if (self.friendCountButton.frame.size.width < MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH)
        [self.friendCountButton resetWidth:MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH];
    
    [self.friendCountButton resetOrigin:CGPointMake(self.participateButton.frame.origin.x - 8 - self.friendCountButton.frame.size.width, MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_ORIGIN_Y)];
    self.friendCountButton.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:self.friendCountButton];
}

#pragma mark - Configure button status methods

- (void)configureParticipateButtonStatus:(BOOL)participated {
    self.participateButton.selected = !participated;
    if (participated) {
        [self.participateButton setTitle:NSLocalizedString(@"Audited", nil) forState:UIControlStateNormal];
    } else {
        [self.participateButton setTitle:NSLocalizedString(@"Audit", nil) forState:UIControlStateNormal];
    }
}

@end
