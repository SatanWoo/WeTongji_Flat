//
//  WESearchResultAvatarCell.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-18.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WESearchResultAvatarCell.h"
#import "Organization+Addition.h"
#import "User+Addition.h"
#import "WEFriendHeadCell.h"

@interface WESearchResultAvatarCell()
@property (nonatomic, strong) NSMutableArray *avatars;
@end

@implementation WESearchResultAvatarCell

- (NSMutableArray *)avatars
{
    if (!_avatars) {
        _avatars = [[NSMutableArray alloc] init];
    }
    return _avatars;
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

- (void)configureWithObject:(LikeableObject *)object
{
    if ([self.avatars count] >= 4) return;
    else if ([self.avatars containsObject:object]) return;
    else {
        [self addObject:object];
    }
}

- (void)addObject:(LikeableObject *)object
{
    [self clearAllAvatars];
    [self.avatars addObject:object];
    [self layoutAvatars];
}

- (void)clearAllAvatars
{
    for (UIView *view in self.avatarContainerView.subviews) {
        [view removeFromSuperview];
    }
}

- (void)layoutAvatars
{
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = [[UIView alloc] init];
    
    [self clearAllAvatars];
    
    for (LikeableObject *object in self.avatars) {
        if ([object isKindOfClass:[Organization class]]) {
            WEFriendHeadCell *cell = [WEFriendHeadCell createFriendCellWithOrg:(Organization *)object];
            [self.avatarContainerView addSubview:cell];
        } else {
            WEFriendHeadCell *cell = [WEFriendHeadCell createFriendCellWithUser:(User *)object];
            [self.avatarContainerView addSubview:cell];
        }
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x += 2;
    //frame.size.width = ;
    [super setFrame:frame];
}

@end
