//
//  WESearchResultHeaderView.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-19.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kWESearchResultHeaderViewHeight 25

@interface WESearchResultHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
+ (WESearchResultHeaderView *)createSearchResultHeaderViewWithName:(NSString *)name;

@end
