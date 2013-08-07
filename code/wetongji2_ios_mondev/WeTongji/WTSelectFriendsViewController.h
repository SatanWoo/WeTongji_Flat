//
//  WTSelectFriendsViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-6-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCoreDataTableViewController.h"

@protocol WTSelectFriendsViewControllerDelegate;

@interface WTSelectFriendsViewController : WTCoreDataTableViewController

@property (nonatomic, weak) id<WTSelectFriendsViewControllerDelegate> delegate;
@property (nonatomic, strong, readonly) NSMutableArray *selectedFriendsArray;

+ (WTSelectFriendsViewController *)showWithDelegate:(id<WTSelectFriendsViewControllerDelegate>)delegate;

@end

@protocol WTSelectFriendsViewControllerDelegate <NSObject>

- (void)selectFriendViewController:(WTSelectFriendsViewController *)vc
                  didSelectFriends:(NSArray *)friendArray;

@optional

- (void)selectFriendViewControllerDidCancel:(WTSelectFriendsViewController *)vc;

@end
