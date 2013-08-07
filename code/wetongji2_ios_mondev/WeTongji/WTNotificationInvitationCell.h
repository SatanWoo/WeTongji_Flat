//
//  WTNotificationInvitationCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-6-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNotificationCell.h"

@class InvitationNotification;

#define CONTENT_LABEL_LINE_SPACING      8.0f

@interface WTNotificationInvitationCell : WTNotificationCell

@property (nonatomic, weak) IBOutlet UIButton *acceptButton;
@property (nonatomic, weak) IBOutlet UIButton *ignoreButton;
@property (nonatomic, weak) IBOutlet UIImageView *acceptedIconImageView;
@property (nonatomic, weak) IBOutlet UIView *buttonContainerView;
@property (nonatomic, weak) IBOutlet UIView *messageContainerView;

- (IBAction)didClickAcceptButton:(UIButton *)sender;

- (IBAction)didClickIgnoreButton:(UIButton *)sender;

- (void)hideButtonsAnimated:(BOOL)animated;

- (void)showButtons;

- (void)showAcceptedIconAnimated:(BOOL)animated;

- (void)hideAcceptedIcon;

+ (CGFloat)cellHeightWithNotificationObject:(InvitationNotification *)notification;

@end
