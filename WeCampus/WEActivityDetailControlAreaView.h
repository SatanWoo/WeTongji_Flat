//
//  WEActivityDetailControlAreaView.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-15.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity+Addition.h"

@interface WEActivityDetailControlAreaView : UIView
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

+ (WEActivityDetailControlAreaView *)createActivityDetailViewWithInfo:(Activity *)act;

@end
