//
//  WESeeAllSchoolEventsHeaderView.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-11.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WESeeAllSchoolEventsHeaderViewDelegate <NSObject>
- (void)didClickSeeAllEvent;
@end

@interface WESeeAllSchoolEventsHeaderView : UIView
@property (weak, nonatomic) id<WESeeAllSchoolEventsHeaderViewDelegate> delegate;

+ (WESeeAllSchoolEventsHeaderView *)createWESeeAllSchoolEventsHeaderView;

@end
