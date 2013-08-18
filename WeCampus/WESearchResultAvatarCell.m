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
    [self.avatars addObject:object];
}

@end
