//
//  WTNewsImageRollView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-19.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTNewsImageRollItemView;

@interface WTNewsImageRollView : UIView

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

+ (WTNewsImageRollView *)createImageRollViewWithImageURLStringArray:(NSArray *)imageURLArray;

- (WTNewsImageRollItemView *)currentItemView;

- (WTNewsImageRollItemView *)itemViewAtIndex:(NSUInteger)index;

- (void)reloadItemImages;

@end

@interface WTNewsImageRollItemView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

+ (WTNewsImageRollItemView *)createItemViewWithImageURLString:(NSString *)imageURLString;

- (void)reloadImage;

@end
