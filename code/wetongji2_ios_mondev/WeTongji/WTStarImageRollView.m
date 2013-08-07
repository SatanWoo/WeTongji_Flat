//
//  WTStarImageRollView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-25.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTStarImageRollView.h"
#import "UIImageView+AsyncLoading.h"

@interface WTStarImageRollView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *itemViewArray;

@end

@implementation WTStarImageRollView

- (WTStarImageRollItemView *)currentItemView {
    if (self.itemViewArray.count == 0)
        return nil;
    return [self itemViewAtIndex:self.pageControl.currentPage];
}

- (WTStarImageRollItemView *)itemViewAtIndex:(NSUInteger)index {
    return [self.itemViewArray objectAtIndex:index];
}

- (void)reloadItemImages {
    for (WTStarImageRollItemView *itemView in self.itemViewArray) {
        [itemView reloadImage];
    }
}

+ (WTStarImageRollView *)createImageRollViewWithImageURLStringArray:(NSArray *)imageURLArray imageDescriptionArray:(NSArray *)descriptionArray {
    WTStarImageRollView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTStarImageRollView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTStarImageRollView class]]) {
            result = (WTStarImageRollView *)view;
            break;
        }
    }
    result.itemViewArray = [NSMutableArray arrayWithCapacity:4];
    
    for (NSInteger i = 0; i < imageURLArray.count; i++) {
        [result addImageViewWithImageURLString:imageURLArray[i] description:descriptionArray[i]];
    }
    
    result.scrollView.contentSize = CGSizeMake(result.scrollView.frame.size.width * result.itemViewArray.count, result.scrollView.frame.size.height);
    result.pageControl.numberOfPages = result.itemViewArray.count;
    
    return result;
}

- (void)addImageViewWithImageURLString:(NSString *)imageURLString description:(NSString *)description {
    WTStarImageRollItemView *itemView = [WTStarImageRollItemView createItemViewWithImageURLString:imageURLString imageDescription:description];
    
    [itemView resetOriginX:self.itemViewArray.count * self.scrollView.frame.size.width];
    
    [self.rightShadowImageView resetOriginX:(self.itemViewArray.count + 1) * self.scrollView.frame.size.width];
    
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

@interface WTStarImageRollItemView ()

@property (nonatomic, copy) NSString *imageURLString;
@property (nonatomic, copy) NSString *descriptionString;

@end

@implementation WTStarImageRollItemView

+ (WTStarImageRollItemView *)createItemViewWithImageURLString:(NSString *)imageURLString imageDescription:(NSString *)description {
    WTStarImageRollItemView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTStarImageRollView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTStarImageRollItemView class]]) {
            result = (WTStarImageRollItemView *)view;
            break;
        }
    }
    
    result.imageURLString = imageURLString;
    result.descriptionString = description;
    
    [result configureView];
    
    return result;
}

- (void)configureView {
    [self.imageView loadImageWithImageURLString:self.imageURLString];
    
    CGFloat descriptionLabelOriginalWidth = self.descriptionLabel.frame.size.width;
    self.descriptionLabel.text = self.descriptionString;
    [self.descriptionLabel sizeToFit];
    [self.descriptionLabel resetWidth:descriptionLabelOriginalWidth];
}

- (void)reloadImage {
    if (!self.imageView.image)
        [self.imageView loadImageWithImageURLString:self.imageURLString success:^(UIImage *image) {
            self.imageView.image = image;
        } failure:nil];
}

@end