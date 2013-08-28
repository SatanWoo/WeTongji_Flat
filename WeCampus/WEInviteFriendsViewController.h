//
//  WEInviteFriendsViewController.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-27.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEContentViewController.h"

@protocol WEInviteFriendsViewControllerDelegate <NSObject>

- (void)cancelInviteFriends;
- (void)finishInviteFriends:(NSArray *)friends;

@end

@interface WEInviteFriendsViewController : WEContentViewController
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *controlArea;
@property (weak, nonatomic) id<WEInviteFriendsViewControllerDelegate> delegate;

+ (WEInviteFriendsViewController *)createInviteFriendsViewControllerWithDelegate:(id<WEInviteFriendsViewControllerDelegate>)target;
- (IBAction)didClickFinishInvitingFriends:(id)sender;
- (IBAction)didClickCancel:(id)sender;

@end
