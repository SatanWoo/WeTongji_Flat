//
//  WESearchResultAvatarCell.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-18.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeableObject+Addition.h"

#define kWESearchAvatarCellHeight 124

@interface WESearchResultAvatarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *avatarContainerView;

- (void)configureWithObject:(LikeableObject *)object;

@end
