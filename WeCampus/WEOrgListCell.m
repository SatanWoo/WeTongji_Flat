//
//  WEOrgListCell.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-29.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEOrgListCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AsyncLoading.h"

@implementation WEOrgListCell

+ (WEOrgListCell *)createOrgListCellWithOrg:(Organization *)org
{
    WEOrgListCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"WEOrgListCell" owner:self options:nil] lastObject];
    [cell configureOrgListWithOrg:org];
    return cell;
}

- (void)configureOrgListWithOrg:(Organization *)org
{
    self.avatarContainerVIew.layer.masksToBounds = YES;
    self.avatarContainerVIew.layer.cornerRadius = 25;
    
    if (org.avatar) {
        [self.avatarImageView loadImageWithImageURLString:org.avatar];
    }
    
    self.titleLabel.text = org.name;
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
