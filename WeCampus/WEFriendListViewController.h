//
//  WEFriendListViewController.h
//  WeCampus
//
//  Created by Song on 13-8-17.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class WEFriendListViewController;

@protocol WEFriendListViewControllerDelegate <NSObject>

- (void)WEFriendListViewController:(WEFriendListViewController*)vc didSelectUser:(User*)user;

@end


@interface WEFriendListViewController : UIViewController
@property (retain,nonatomic) User *friendOfPerson;
@property (nonatomic,assign) id<WEFriendListViewControllerDelegate> delegate;

- (NSArray*)selectedUsers;

- (void)unselectAll;

@end
