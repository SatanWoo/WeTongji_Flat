//
//  WTNotificationFriendInvitationCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNotificationFriendInvitationCell.h"
#import "FriendInvitationNotification.h"
#import "Notification+Addition.h"
#import "User+Addition.h"
#import "WeTongjiSDK.h"
#import "NSString+WTAddition.h"
#import "WTCoreDataManager.h"

@interface WTNotificationFriendInvitationCell()

@end

@implementation WTNotificationFriendInvitationCell

#pragma mark - Class methods

+ (NSMutableAttributedString *)generateNotificationContentAttributedString:(FriendInvitationNotification *)invitation {
        
    NSMutableAttributedString* messageContentString = nil;
    
    if (invitation.sender != [WTCoreDataManager sharedManager].currentUser) {
        NSString *senderName = invitation.sender.name;
        NSMutableAttributedString* senderNameString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"%@ ", senderName]];
        [senderNameString setTextBold:YES range:NSMakeRange(0, senderNameString.length)];
        [senderNameString setTextColor:[UIColor blackColor]];
        
        messageContentString = [NSMutableAttributedString attributedStringWithString:@"想要加您为好友"];
        [messageContentString setTextColor:WTNotificationCellLightGrayColor];
        
        [messageContentString insertAttributedString:senderNameString atIndex:0];
    } else {
        NSString *receiverName = invitation.receiver.name;
        NSMutableAttributedString *receiverNameString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"%@ ", receiverName]];
        [receiverNameString setTextBold:YES range:NSMakeRange(0, receiverNameString.length)];
        [receiverNameString setTextColor:[UIColor blackColor]];
                
        messageContentString = [NSMutableAttributedString attributedStringWithString:@"接受了您好友的邀请"];
        [messageContentString setTextColor:WTNotificationCellLightGrayColor];
        [messageContentString insertAttributedString:receiverNameString atIndex:0];
    }
    
    [messageContentString setFont:[UIFont systemFontOfSize:14.0f]];
    [messageContentString modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
        paragraphStyle.lineSpacing = CONTENT_LABEL_LINE_SPACING;
    }];
    
    return messageContentString;
}

- (void)configureTypeIconImageView {
    CourseInvitationNotification *courseInvitation = (CourseInvitationNotification *)self.notification;
    if (courseInvitation.accepted.boolValue) {
        [self.notificationTypeIconImageView setHidden:NO];
        self.notificationTypeIconImageView.image = [UIImage imageNamed:@"message_accept"];
    } else {
        [self.notificationTypeIconImageView setHidden:YES];
    }
}

#pragma mark - Actions

- (IBAction)didClickAcceptButton:(UIButton *)sender {
    FriendInvitationNotification *friendInvitation = (FriendInvitationNotification *)self.notification;

    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        friendInvitation.accepted = @(YES);
        [self hideButtonsAnimated:YES];
        [self showAcceptedIconAnimated:YES];
        [self configureTypeIconImageView];
        [[WTCoreDataManager sharedManager].currentUser addFriendsObject:friendInvitation.sender];
        [self.delegate cellHeightDidChange];
    } failureBlock:^(NSError *error) {
    }];
    [request acceptFriendInvitation:friendInvitation.sourceID];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (IBAction)didClickIgnoreButton:(UIButton *)sender {
    FriendInvitationNotification *friendInvitation = (FriendInvitationNotification *)self.notification;
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        [Notification deleteNotificationWithID:friendInvitation.identifier];
    } failureBlock:^(NSError *error) {
    }];
    [request ignoreFriendInvitation:friendInvitation.sourceID];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)configureUIWithNotificaitonObject:(Notification *)notification {
    [super configureUIWithNotificaitonObject:notification];
    [self configureTypeIconImageView];
}

@end
