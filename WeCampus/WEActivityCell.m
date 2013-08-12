//
//  WEActivityCell.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-12.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEActivityCell.h"
#define kWEActivityCellNibName @"WEActivityCell"

@implementation WEActivityCell

+ (WEActivityCell *)createWEActivityCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:kWEActivityCellNibName owner:nil options:nil];
    WEActivityCell *cell = [array lastObject];
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
