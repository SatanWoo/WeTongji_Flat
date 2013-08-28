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

@protocol WEActivityDetailContentViewDelegate <NSObject>

- (void)shouldDismissDetailImageView;

@end

@interface WEActivityDetailContentView : UITableViewCell
@property (weak, nonatomic) IBOutlet OHAttributedLabel *contentLabel;
@property (weak, nonatomic) id<WEActivityDetailContentViewDelegate> delegate;
@property (weak, nonatomic) UIViewController *containerViewController;

- (UIImage *)currentImage;
+ (WEActivityDetailContentView *)createDetailContentViewWithInfo:(Activity *)act;
- (void)resetLayout:(CGFloat)percent;
- (void)resetNormalLayout;
- (void)resetTransparentLayout;
@end
