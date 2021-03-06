//
//  WEFriendHeadCell.h
//  WeCampus
//
//  Created by Song on 13-8-17.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+Addition.h"
#import "Organization+Addition.h"

@interface WEFriendHeadCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain,nonatomic,readonly) id obj;
- (void)configureWithUser:(User*)user;
- (void)configureWithOrg:(Organization *)org;

+ (WEFriendHeadCell *)createFriendCellWithUser:(User *)user;
+ (WEFriendHeadCell *)createFriendCellWithOrg:(Organization *)org;

@end
