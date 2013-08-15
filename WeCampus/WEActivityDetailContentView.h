//
//  WEActivityDetailContentView.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-15.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OHAttributedLabel.h>
#import "Activity+Addition.h"

@interface WEActivityDetailContentView : UIView
@property (weak, nonatomic) IBOutlet OHAttributedLabel *contentLabel;

+ (WEActivityDetailContentView *)createDetailContentViewWithInfo:(Activity *)act;

@end
