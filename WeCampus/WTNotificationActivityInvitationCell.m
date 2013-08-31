//
//  WTNotificationActivityInvitationCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNotificationActivityInvitationCell.h"
#import "WeTongjiSDK.h"
#import "ActivityInvitationNotification.h"
#import "Notification+Addition.h"
#import "Activity+Addition.h"
#import "User+Addition.h"
#import "WTCoreDataManager.h"

@implementation WTNotificationActivityInvitationCell

#pragma mark - Class methods

+ (NSMutableAttributedString *)generateNotificationContentAttributedString:(ActivityInvitationNotification *)invitation {
    
    NSMutableAttributedString* messageContentString = nil;
    NSString *activityTitle = invitation.activity.what;
    
    NSMutableAttributedString* activityTitleString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@" %@", activityTitle]];
    [activityTitleString setTextBold:YES range:NSMakeRange(0, activityTitleString.length)];
    
    NSLog(@"act is %@", activityTitleString);
    if (invitation.sender != [WTCoreDataManager sharedManager].currentUser) {
        NSString *senderName = invitation.sender.name;
        NSMutableAttributedString* senderNameString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"%@ ", senderName]];
        [senderNameString setTextBold:YES range:NSMakeRange(0, senderNameString.length)];
        [senderNameString setTextColor:[UIColor blackColor]];
        
        [activityTitleString setTextColor:[UIColor blackColor]];
        
        messageContentString = [NSMutableAttributedString attributedStringWithString:@"邀请您参加 "];
        [messageContentString setTextColor:WTNotificationCellLightGrayColor];
        
        [messageContentString insertAttributedString:senderNameString atIndex:0];
        [messageContentString insertAttributedString:activityTitleString atIndex:messageContentString.length - 1];
    } else {
        NSString *receiverName = invitation.receiver.name;
        NSMutableAttributedString *receiverNameString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"%@ ", receiverName]];
        [receiverNameString setTextBold:YES range:NSMakeRange(0, receiverNameString.length)];
        [receiverNameString setTextColor:[UIColor blackColor]];
        
        [activityTitleString setTextColor:[UIColor blackColor]];
        

        messageContentString = [NSMutableAttributedString attributedStringWithString:@"接受了您参加的邀请。"];
        [messageContentString setTextColor:WTNotificationCellLightGrayColor];
        [messageContentString insertAttributedString:receiverNameString atIndex:0];
        [messageContentString insertAttributedString:activityTitleString atIndex:messageContentString.length - 4];
    }
    
    [messageContentString setFont:[UIFont systemFontOfSize:14.0f]];
    NSLog(@"message is %@", messageContentString);
    [messageContentString modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
        paragraphStyle.lineSpacing = CONTENT_LABEL_LINE_SPACING;
    }];
    
    return messageContentString;
}

- (void)configureTypeIconImageView {
    ActivityInvitationNotification *activityInvitation = (ActivityInvitationNotification *)self.notification;
    if (activityInvitation.accepted.boolValue) {
        [self.notificationTypeIconImageView setHidden:NO];
        self.notificationTypeIconImageView.image = [UIImage imageNamed:@"message_accept"];
    } else {
        [self.notificationTypeIconImageView setHidden:YES];
    }
}

#pragma mark - Actions

- (IBAction)didClickAcceptButton:(UIButton *)sender {
    ActivityInvitationNotification *activityInvitation = (ActivityInvitationNotification *)self.notification;
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        NSLog(@"Accept activity invitation:%@", responseObject);
        activityInvitation.accepted = @(YES);
        [self hideButtonsAnimated:YES];
        [self showAcceptedIconAnimated:YES];
        [self configureTypeIconImageView];
        activityInvitation.activity.scheduledByCurrentUser = YES;
        [self.delegate cellHeightDidChange];
    } failureBlock:^(NSError *error) {
    }];
    [request acceptActivityInvitation:activityInvitation.sourceID];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (IBAction)didClickIgnoreButton:(UIButton *)sender {
    ActivityInvitationNotification *activityInvitation = (ActivityInvitationNotification *)self.notification;
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        [Notification deleteNotificationWithID:activityInvitation.identifier];
    } failureBlock:^(NSError *error) {
    }];
    [request ignoreActivityInvitation:activityInvitation.sourceID];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)configureUIWithNotificaitonObject:(Notification *)notification {
    [super configureUIWithNotificaitonObject:notification];
    [self configureTypeIconImageView];
}

@end
