//
//  WTNowBarTitleView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-15.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WTNowBarTitleViewDelegate;

@interface WTNowBarTitleView : UIView

@property (nonatomic, assign) NSUInteger weekNumber;

- (IBAction)didClickPrevButton:(UIButton *)sender;

- (IBAction)didClickNextButton:(UIButton *)sender;

+ (WTNowBarTitleView *)createBarTitleViewWithDelegate:(id<WTNowBarTitleViewDelegate>)delegate;

@end

@protocol WTNowBarTitleViewDelegate <NSObject>

- (void)nowBarTitleViewWeekNumberDidChange:(WTNowBarTitleView *)titleView;

@end