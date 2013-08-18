//
//  WEFriendListHeaderView.h
//  WeCampus
//
//  Created by Song on 13-8-18.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WEFriendListHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *label;


- (void)configureWithString:(NSString*)str;

@end
