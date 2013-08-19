//
//  WEFriendHeadCell.m
//  WeCampus
//
//  Created by Song on 13-8-17.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEFriendHeadCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AsyncLoading.h"

@implementation WEFriendHeadCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"WEFriendHeadCell" owner:self options:nil];
//        
//        if ([arrayOfViews count] < 1) {
//            return nil;
//        }
//        
//        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
//            return nil;
//        }
//        
//        self = [arrayOfViews objectAtIndex:0];
//        
//        self.avatarImageView = (UIImageView*)[self viewWithTag:1];
//        self.nameLabel = (UILabel*)[self viewWithTag:2];
        
        // Initialization code
    }
    return self;
}

+ (WEFriendHeadCell *)createFriendCellWithUser:(User *)user
{
    WEFriendHeadCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"WEFriendHeadCell" owner:self options:nil] lastObject];
    [cell configureWithUser:user];
    return cell;
}

+ (WEFriendHeadCell *)createFriendCellWithOrg:(Organization *)org
{
    WEFriendHeadCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"WEFriendHeadCell" owner:self options:nil] lastObject];
    [cell configureWithOrg:org];
    return cell;
}

- (void)configureWithOrg:(Organization *)org
{
    [self configureCellWithImage:org.avatar andName:org.name];
}

- (void)configureWithUser:(User*)user
{
    [self configureCellWithImage:user.avatar andName:user.name];
}

- (void)configureCellWithImage:(NSString *)imgURL andName:(NSString *)name
{
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height / 2;
    [self.avatarImageView loadImageWithImageURLString:imgURL];
    self.nameLabel.text = name;
    [self.nameLabel sizeToFit];
    [self.nameLabel resetCenterX:self.frame.size.width / 2];
}

@end
