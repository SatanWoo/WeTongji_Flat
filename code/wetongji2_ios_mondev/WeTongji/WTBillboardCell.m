//
//  WTBillboardCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBillboardCell.h"
#import "WTBillboardItemView.h"

@interface WTBillboardCell ()

@property (nonatomic, strong) WTBillboardItemView *largeItemView;
@property (nonatomic, strong) WTBillboardItemView *smallItemViewA;
@property (nonatomic, strong) WTBillboardItemView *smallItemViewB;

@end

@implementation WTBillboardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib {
    self.largeItemView = [WTBillboardItemView createLargeItemView];
    self.smallItemViewA = [WTBillboardItemView createSmallItemView];
    self.smallItemViewB = [WTBillboardItemView createSmallItemView];
    
    [self.smallItemViewA resetOriginY:3.0f];
    [self.smallItemViewB resetOriginY:103.0f];
    
    [self addSubview:self.largeItemView];
    [self addSubview:self.smallItemViewA];
    [self addSubview:self.smallItemViewB];
}

- (void)configureCellWithBillboardPosts:(NSArray *)posts
                              indexPath:(NSIndexPath *)indexPath {
    NSMutableArray *itemViewArray = [NSMutableArray arrayWithCapacity:3];
    if (indexPath.row % 2 == 0) {
        [self.largeItemView resetOriginX:9.0f];
        [self.smallItemViewA resetOriginX:self.largeItemView.frame.size.width + self.largeItemView.frame.origin.x + 2.0f];
        [self.smallItemViewB resetOriginX:self.smallItemViewA.frame.origin.x];
        [itemViewArray addObjectsFromArray:@[self.largeItemView, self.smallItemViewA, self.smallItemViewB]];
    } else {
        [self.smallItemViewA resetOriginX:9.0f];
        [self.smallItemViewB resetOriginX:self.smallItemViewA.frame.origin.x];
        [self.largeItemView resetOriginX:self.smallItemViewA.frame.size.width + self.smallItemViewA.frame.origin.x + 2.0f];
        [itemViewArray addObjectsFromArray:@[self.smallItemViewA, self.smallItemViewB, self.largeItemView]];
    }
    
    for (WTBillboardItemView *itemView in itemViewArray) {
        itemView.hidden = YES;
    }
    
    NSUInteger index = 0;
    for (BillboardPost *post in posts) {
        WTBillboardItemView *itemView = itemViewArray[index];
        itemView.hidden = NO;
        
        [itemView configureViewWithBillboardPost:post];
        
        index++;
    }
}

@end