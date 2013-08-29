//
//  WEOrgListCell.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-29.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Organization+Addition.h"

@interface WEOrgListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *avatarContainerVIew;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (WEOrgListCell *)createOrgListCellWithOrg:(Organization *)org;
- (void)configureOrgListWithOrg:(Organization *)org;

@end
