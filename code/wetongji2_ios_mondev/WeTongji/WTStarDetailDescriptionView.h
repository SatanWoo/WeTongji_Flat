//
//  WTStarDetailDescriptionView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-6-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OHAttributedLabel;
@class Star;

@interface WTStarDetailDescriptionView : UIView

@property (nonatomic, weak) IBOutlet UIView *contentContainerView;
@property (nonatomic, weak) IBOutlet UILabel *aboutDisplayLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIView *titleContainerView;

+ (WTStarDetailDescriptionView *)createDetailDescriptionViewWithStar:(Star *)star;

@end
