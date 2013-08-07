//
//  WTNewsImageRollView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-19.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNewsImageRollView.h"
#import "UIImageView+AsyncLoading.h"
#import <QuartzCore/QuartzCore.h>

@interface WTNewsImageRollView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *itemViewArray;

@end

@implementation WTNewsImageRollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (WTNewsImageRollItemView *)currentItemView {
    if (self.itemViewArray.count == 0)
        return nil;
    return [self itemViewAtIndex:self.pageControl.currentPage];
}

- (WTNewsImageRollItemView *)itemViewAtIndex:(NSUInteger)index {
    return [self.itemViewArray objectAtIndex:index];
}

- (void)reloadItemImages {
    for (WTNewsImageRollItemView *itemView in self.itemViewArray) {
        [itemView reloadImage];
    }
}

+ (WTNewsImageRollView *)createImageRollViewWithImageURLStringArray:(NSArray *)imageURLArray {
    WTNewsImageRollView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTNewsImageRollView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTNewsImageRollView class]]) {
            result = (WTNewsImageRollView *)view;
            break;
        }
    }
    result.itemViewArray = [NSMutableArray arrayWithCapacity:4];
    
    for (NSString *imageURLString in imageURLArray) {
        [result addImageViewWithImageURLString:imageURLString];
    }
    
    result.scrollView.contentSize = CGSizeMake(result.scrollView.frame.size.width * result.itemViewArray.count, result.scrollView.frame.size.height);
    result.pageControl.numberOfPages = result.itemViewArray.count;
    
    return result;
}

- (void)addImageViewWithImageURLString:(NSString *)imageURLString {
    WTNewsImageRollItemView *itemView = [WTNewsImageRollItemView createItemViewWithImageURLString:imageURLString];
    
    itemView.center = CGPointMake((self.scrollView.frame.size.width * (self.itemViewArray.count * 2 + 1)) / 2, self.scrollView.frame.size.height / 2);
    [self.scrollView addSubview:itemView];
    [self.itemViewArray addObject:itemView];
}

- (void)updateScrollView {
    int currentPage = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    self.pageControl.currentPage = currentPage;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [self updateScrollView];
    }
}

@end

@interface WTNewsImageRollItemView ()

@property (nonatomic, copy) NSString *imageURLString;

@end

@implementation WTNewsImageRollItemView

+ (WTNewsImageRollItemView *)createItemViewWithImageURLString:(NSString *)imageURLString {
    WTNewsImageRollItemView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTNewsImageRollView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTNewsImageRollItemView class]]) {
            result = (WTNewsImageRollItemView *)view;
            break;
        }
    }
    
    result.imageURLString = imageURLString;
    
    [result.imageView loadImageWithImageURLString:imageURLString];
    
    return result;
}

- (void)reloadImage {
    if (!self.imageView.image)
        [self.imageView loadImageWithImageURLString:self.imageURLString success:^(UIImage *image) {
            self.imageView.image = image;
        } failure:nil];
}

@end
