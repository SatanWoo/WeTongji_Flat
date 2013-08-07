//
//  WTPullTableHeaderView.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-12.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WTPullTableHeaderViewStateNormal = 1 << 0,
    WTPullTableHeaderViewStatePull = 1 << 1,
    WTPullTableHeaderViewStateLoad = 1 << 2
} WTPullTableHeaderViewState;

@protocol WTPullTableHeaderViewDelegate <NSObject>
@optional
- (NSDateFormatter *)updateDateFormat;
@required
- (void)pullToLoadData;
@end

@interface WTPullTableHeaderView : UIView

@property (nonatomic, weak) IBOutlet UILabel *updatedTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *informationLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, assign) WTPullTableHeaderViewState state;
@property (nonatomic, assign) id<WTPullTableHeaderViewDelegate> delegate;

- (void)pullTableHeaderViewDidEndDragging:(UIScrollView *)scrollView;
- (void)pullTableHeaderViewDidFinishingLoading:(UIScrollView *)scrollView;
- (void)pullTableHeaderViewDidScroll:(UIScrollView *)scrollView;

@end
