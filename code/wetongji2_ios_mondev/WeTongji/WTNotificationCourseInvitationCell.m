//
//  WTNotificationCourseInvitationCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNotificationCourseInvitationCell.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "CourseInvitationNotification.h"
#import "Notification+Addition.h"
#import "Course+Addition.h"
#import "User+Addition.h"
#import "WTCoreDataManager.h"

@implementation WTNotificationCourseInvitationCell

#pragma mark - Class methods

+ (NSMutableAttributedString *)generateNotificationContentAttributedString:(CourseInvitationNotification *)invitation {
    
    NSMutableAttributedString* messageContentString = nil;
    NSString *courseTitle = invitation.course.courseName;
    BOOL accepted = invitation.accepted.boolValue;
    
    NSMutableAttributedString *courseTitleString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@" %@", courseTitle]];
    [courseTitleString setTextBold:YES range:NSMakeRange(0, courseTitleString.length)];
    
    if (invitation.sender != [WTCoreDataManager sharedManager].currentUser) {
        NSString *senderName = invitation.sender.name;
        NSMutableAttributedString* senderNameString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"%@ ", senderName]];
        [senderNameString setTextBold:YES range:NSMakeRange(0, senderNameString.length)];
        [senderNameString setTextColor:accepted ? WTNotificationCellDarkGrayColor : [UIColor whiteColor]];
        
        [courseTitleString setTextColor:accepted ? WTNotificationCellDarkGrayColor : [UIColor whiteColor]];
        
        messageContentString = [NSMutableAttributedString attributedStringWithString:NSLocalizedString(@"invites you to audit.", nil)];
        [messageContentString setTextColor:accepted ? WTNotificationCellDarkGrayColor : WTNotificationCellLightGrayColor];
        
        [messageContentString insertAttributedString:senderNameString atIndex:0];
        [messageContentString insertAttributedString:courseTitleString atIndex:messageContentString.length - 1];
    } else {
        NSString *receiverName = invitation.receiver.name;
        NSMutableAttributedString *receiverNameString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"%@ ", receiverName]];
        [receiverNameString setTextBold:YES range:NSMakeRange(0, receiverNameString.length)];
        [receiverNameString setTextColor:[UIColor whiteColor]];
        
        [courseTitleString setTextColor:[UIColor whiteColor]];
        
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        if ([language isEqualToString:@"zh-Hans"]) {
            messageContentString = [NSMutableAttributedString attributedStringWithString:@"接受了您旁听 的邀请。"];
            [messageContentString setTextColor:WTNotificationCellLightGrayColor];
            [messageContentString insertAttributedString:receiverNameString atIndex:0];
            [messageContentString insertAttributedString:courseTitleString atIndex:messageContentString.length - 5];
        } else if ([language isEqualToString:@"de"]) {
            messageContentString = [NSMutableAttributedString attributedStringWithString:@"Ihrer Kurs Einladung zu akzeptiert."];
            [messageContentString setTextColor:WTNotificationCellLightGrayColor];
            [messageContentString insertAttributedString:receiverNameString atIndex:0];
            [messageContentString insertAttributedString:courseTitleString atIndex:messageContentString.length - 12];
        } else {
            messageContentString = [NSMutableAttributedString attributedStringWithString:@"accepted your auditing invitation to."];
            [messageContentString setTextColor:WTNotificationCellLightGrayColor];
            [messageContentString insertAttributedString:receiverNameString atIndex:0];
            [messageContentString insertAttributedString:courseTitleString atIndex:messageContentString.length - 1];
        }
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
        self.notificationTypeIconImageView.image = [UIImage imageNamed:@"WTNotificationAcceptIcon"];
    } else {
        self.notificationTypeIconImageView.image = [UIImage imageNamed:@"WTNotificationQuestionIcon"];
    }
}

#pragma mark - Actions

- (IBAction)didClickAcceptButton:(UIButton *)sender {
    CourseInvitationNotification *courseInvitation = (CourseInvitationNotification *)self.notification;
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        NSLog(@"Accept course invitation:%@", responseObject);
        courseInvitation.accepted = @(YES);
        [self hideButtonsAnimated:YES];
        [self showAcceptedIconAnimated:YES];
        [self configureTypeIconImageView];
        courseInvitation.course.registeredByCurrentUser = YES;
        [self.delegate cellHeightDidChange];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Accept course invitation:%@", error.localizedDescription);
        [WTErrorHandler handleError:error];
    }];
    [request acceptCourseInvitation:courseInvitation.sourceID];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (IBAction)didClickIgnoreButton:(UIButton *)sender {
    CourseInvitationNotification *courseInvitation = (CourseInvitationNotification *)self.notification;
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        NSLog(@"Reject course invitation success:%@", responseObject);
        [Notification deleteNotificationWithID:courseInvitation.identifier];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Reject course invitation:%@", error.localizedDescription);
        [WTErrorHandler handleError:error];
    }];
    [request ignoreCourseInvitation:courseInvitation.sourceID];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)configureUIWithNotificaitonObject:(Notification *)notification {
    [super configureUIWithNotificaitonObject:notification];
    [self configureTypeIconImageView];
}

@end
