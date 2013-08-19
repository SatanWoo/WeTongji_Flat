//
//  WESearchResultHeaderView.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-19.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WESearchResultHeaderView : UIView

+ (WESearchResultHeaderView *)createSearchResultHeaderViewWithName:(NSString *)name;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
