//
//  WEFriendListHeaderView.m
//  WeCampus
//
//  Created by Song on 13-8-18.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEFriendListHeaderView.h"

@implementation WEFriendListHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"WEFriendListHeaderView" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionReusableView class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
        self.label = (UILabel*)[self viewWithTag:1];
        
    }
    return self;
}

- (void)configureWithString:(NSString*)str
{
    self.label.text = str;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
