//
//  WTStarHeaderView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-6-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Star;

@interface WTStarHeaderView : UIView

@property (nonatomic, weak) IBOutlet UIView *avatarContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *mottoLabel;
@property (nonatomic, weak) IBOutlet UILabel *starNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *volumeLabel;

+ (WTStarHeaderView *)createHeaderViewWithStar:(Star *)star;

@end
