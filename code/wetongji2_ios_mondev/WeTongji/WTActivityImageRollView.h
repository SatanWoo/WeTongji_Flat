//
//  WTActivityImageRollView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-25.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTActivityImageRollItemView;

@interface WTActivityImageRollView : UIView

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UIImageView *rightShadowImageView;

+ (WTActivityImageRollView *)createImageRollViewWithImageURLStringArray:(NSArray *)imageURLArray;

- (WTActivityImageRollItemView *)currentItemView;

- (WTActivityImageRollItemView *)itemViewAtIndex:(NSUInteger)index;

- (void)reloadItemImages;

@end

@interface WTActivityImageRollItemView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

+ (WTActivityImageRollItemView *)createItemViewWithImageURLString:(NSString *)imageURLString;

- (void)reloadImage;

@end
