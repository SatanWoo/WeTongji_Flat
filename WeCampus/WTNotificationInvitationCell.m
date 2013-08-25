//
//  WTNotificationInvitationCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-6-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNotificationInvitationCell.h"
#import "WTNotificationActivityInvitationCell.h"
#import "WTNotificationFriendInvitationCell.h"
#import "WTNotificationCourseInvitationCell.h"
#import "OHAttributedLabel.h"
#import "ActivityInvitationNotification.h"
#import "FriendInvitationNotification.h"
#import "CourseInvitationNotification.h"
#import "Activity+Addition.h"
#import "User+Addition.h"
#import "Course+Addition.h"
#import "WTCoreDataManager.h"

#define CELL_ORIGINAL_HEIGHT            120.0f
#define BUTTON_CONTAINER_VIEW_HEIGHT    50.0f
#define CONTENT_LABEL_WIDTH             232.0f
#define CONTENT_LABEL_ORIGINAL_HEIGHT   18.0f

@implementation WTNotificationInvitationCell

#pragma mark - Class methods

+ (NSAttributedString *)generateContentAttributedStringWithNotificationObject:(InvitationNotification *)notification {
    NSAttributedString *result = nil;
    if ([notification isKindOfClass:[ActivityInvitationNotification class]]) {
        ActivityInvitationNotification *activityInvitation = (ActivityInvitationNotification *)notification;
        result = [WTNotificationActivityInvitationCell generateNotificationContentAttributedString:activityInvitation];
    } else if ([notification isKindOfClass:[CourseInvitationNotification class]]) {
        CourseInvitationNotification *courseInvitation = (CourseInvitationNotification *)notification;
        result = [WTNotificationCourseInvitationCell generateNotificationContentAttributedString:courseInvitation];
    } else if ([notification isKindOfClass:[FriendInvitationNotification class]]) {
        FriendInvitationNotification *friendInvitation = (FriendInvitationNotification *)notification;
        result = [WTNotificationFriendInvitationCell generateNotificationContentAttributedString:friendInvitation];
    } 
    return result;
}

+ (CGFloat)cellHeightWithNotificationObject:(InvitationNotification *)notification {
    NSAttributedString *contentAttributedString = [WTNotificationInvitationCell generateContentAttributedStringWithNotificationObject:notification];
    CGFloat result = 0;
    CGFloat contentLabelRealHeight = [contentAttributedString sizeConstrainedToSize:CGSizeMake(CONTENT_LABEL_WIDTH, 20000.0f)].height;
    CGFloat contentLabelGrowHeight = contentLabelRealHeight - CONTENT_LABEL_ORIGINAL_HEIGHT;
    if (notification.accepted.boolValue) {
        result = CELL_ORIGINAL_HEIGHT - BUTTON_CONTAINER_VIEW_HEIGHT + contentLabelGrowHeight;
    } else {
        result = CELL_ORIGINAL_HEIGHT + contentLabelGrowHeight;
    }
    return result;
}

#pragma mark - UI methods

- (void)hideButtonsAnimated:(BOOL)animated {
    if (animated) {
        UIViewAutoresizing notificationContentLabelResizing = self.notificationContentLabel.autoresizingMask;
        UIViewAutoresizing timeLabelResizing = self.timeLabel.autoresizingMask;
        
        self.notificationContentLabel.autoresizingMask = self.avatarContainerView.autoresizingMask;
        self.timeLabel.autoresizingMask = self.avatarContainerView.autoresizingMask;
        
        [self.buttonContainerView fadeOutWithCompletion:^{
            self.notificationContentLabel.autoresizingMask = notificationContentLabelResizing;
            self.timeLabel.autoresizingMask = timeLabelResizing;
        }];
    }
    else {
        self.buttonContainerView.alpha = 0;
    }
}

- (void)showButtons {
    self.buttonContainerView.alpha = 1;
}

- (void)showAcceptedIconAnimated:(BOOL)animated {
    self.acceptedIconImageView.hidden = NO;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"zh-Hans"]) {
        self.acceptedIconImageView.image = [UIImage imageNamed:@"WTInvitationAcceptedIconCN"];
    } else {
        self.acceptedIconImageView.image = [UIImage imageNamed:@"WTInvitationAcceptedIconEN"];
    }
    
    if (animated) {
        self.acceptedIconImageView.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
        [UIView animateWithDuration:0.15f animations:^{
            self.acceptedIconImageView.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)hideAcceptedIcon {
    self.acceptedIconImageView.hidden = YES;
}

- (void)configureNotificationContentLabel {
    self.notificationContentLabel.attributedText = [WTNotificationInvitationCell generateContentAttributedStringWithNotificationObject:(InvitationNotification *)self.notification];
}

#pragma mark - Methods to overwrite

- (void)configureUIWithNotificaitonObject:(Notification *)notification {
    [super configureUIWithNotificaitonObject:notification];
    
    InvitationNotification *invitation = (InvitationNotification *)notification;
    if (invitation.accepted.boolValue) {
        [self hideButtonsAnimated:NO];
        if (invitation.sender != [WTCoreDataManager sharedManager].currentUser)
            [self showAcceptedIconAnimated:NO];
        else
            [self hideAcceptedIcon];
    } else {
        [self showButtons];
        [self hideAcceptedIcon];
        
        [self.ignoreButton setTitle:NSLocalizedString(@"Ignore", nil) forState:UIControlStateNormal];
        [self.acceptButton setTitle:NSLocalizedString(@"Accept", nil) forState:UIControlStateNormal];
    }
    
    [self configureNotificationContentLabel];
    
    CGFloat cellHeight = [WTNotificationInvitationCell cellHeightWithNotificationObject:invitation];
    [self resetHeight:cellHeight];
    [self.messageContainerView resetHeight:invitation.accepted.boolValue ? cellHeight : cellHeight - BUTTON_CONTAINER_VIEW_HEIGHT];
}

- (IBAction)didClickAcceptButton:(UIButton *)sender {
    
}

- (IBAction)didClickIgnoreButton:(UIButton *)sender {
    
}

@end
