//
//  WTNotificationCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"

@class Notification;

@protocol WTNotificationCellDelegate <NSObject>

- (void)cellHeightDidChange;

@end

@interface WTNotificationCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIView *avatarContainerView;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *notificationContentLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *notificationTypeIconImageView;
@property (nonatomic, weak) id<WTNotificationCellDelegate> delegate;
@property (nonatomic, weak) Notification *notification;

- (void)configureUIWithNotificaitonObject:(Notification *)notification;

@end
