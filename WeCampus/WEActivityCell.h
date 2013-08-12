//
//  WEActivityCell.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-12.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WEActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendPeopleCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;

+ (WEActivityCell *)createWEActivityCell;

@end
