//
//  WEBannerContainerView.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-11.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEBannerContainerView.h"
#import "WEBannerItemView.h"
#import "UIImageView+AsyncLoading.h"
#define kWEBannerContainerViewNibName @"WEBannerContainerView"

@interface WEBannerContainerView() <UIScrollViewDelegate>
@property (strong, nonatomic) NSMutableArray *bannerItemViewArray;
@property (strong, nonatomic) NSMutableArray *bannerObjectArray;
@property (assign, nonatomic) NSUInteger bannerItemCount;
@end

@implementation WEBannerContainerView

#pragma mark - Public

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (WEBannerContainerView *)createBannerContainerView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:kWEBannerContainerViewNibName owner:nil options:nil];
    return [array lastObject];
}

- (WEBannerItemView *)addItemViewWithModelObject:(Object *)object {
    self.bannerItemCount = self.bannerItemCount + 1;
    NSInteger index = self.bannerItemCount - 1;
    WEBannerItemView *itemView = self.bannerItemViewArray[index];
    [itemView configureViewWithModelObject:object];
    
    return itemView;
}

- (void)reloadItemImages {
    for (WEBannerItemView *itemView in self.bannerItemViewArray) {
        if (!itemView.imageView.image) {
            [itemView.imageView loadImageWithImageURLString:itemView.imageURLString success:^(UIImage *image) {
                itemView.imageView.image = image;
            } failure:nil];
        }
    }
}

- (WEBannerItemView *)itemViewAtIndex:(NSUInteger)index {
    return self.bannerItemViewArray[index];
}

- (WEBannerItemView *)currentItemView {
    if (self.bannerItemViewArray.count == 0)
        return nil;
    return [self itemViewAtIndex:self.pageControl.currentPage];
}

- (void)autoScroll
{
    NSInteger count = self.pageControl.numberOfPages;
    NSInteger currentIndex = self.pageControl.currentPage;
    if (currentIndex < count - 1) {
        currentIndex ++;
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * currentIndex, 0) animated:YES];
    } else {
        currentIndex = 0;
        [self.scrollView setContentOffset:CGPointZero animated:NO];
    }
    
    self.pageControl.currentPage = currentIndex;
}

#pragma mark - Properties

- (NSMutableArray *)bannerItemViewArray {
    if (_bannerItemViewArray == nil) {
        _bannerItemViewArray = [[NSMutableArray alloc] init];
    }
    return _bannerItemViewArray;
}

- (NSMutableArray *)bannerObjectArray {
    if (_bannerObjectArray == nil) {
        _bannerObjectArray = [[NSMutableArray alloc] init];
    }
    return  _bannerObjectArray;
}

- (void)setBannerItemCount:(NSUInteger)bannerItemCount {
    if (bannerItemCount > _bannerItemCount) {
        for(NSUInteger i = _bannerItemCount; i < bannerItemCount; i++) {
            WEBannerItemView *itemView = [self createBannerItemViewAtIndex:i];
            [self.bannerItemViewArray addObject:itemView];
            [self.scrollView addSubview:itemView];
        }
    } else if (bannerItemCount < _bannerItemCount) {
        for(NSUInteger i = bannerItemCount; i < _bannerItemCount; i++) {
            WEBannerItemView *itemView = self.bannerItemViewArray[i];
            [itemView removeFromSuperview];
        }
        [self.bannerItemViewArray removeAllObjects];
    } else
        return;
    
    _bannerItemCount = bannerItemCount;
    self.pageControl.numberOfPages = bannerItemCount;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * bannerItemCount, self.scrollView.frame.size.height);
}

#pragma mark - UI methods

- (WEBannerItemView *)createBannerItemViewAtIndex:(NSUInteger)index {
    WEBannerItemView *result = [WEBannerItemView createBannerItemView];
    [result resetOrigin:CGPointMake(self.scrollView.frame.size.width * index, 0)];
    result.backgroundColor = [UIColor clearColor];
    return result;
}

- (void)updateBannerPateControl {
    int currentPage = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    NSLog(@"currentPage is %d", currentPage);
    
    if (currentPage == 0) { // Means the first item
                            // Counterclosewise scroll from leftmost
        [self.scrollView setContentOffset:CGPointMake((self.bannerItemCount - 2) * self.scrollView.frame.size.width, 0) animated:NO];
        currentPage = self.pageControl.numberOfPages - 1;
    } else if (currentPage == self.pageControl.numberOfPages + 1){
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
        currentPage = 0;
    } else {
        currentPage --;
    }
    
    self.pageControl.currentPage = currentPage;
}

- (void)configureBannerWithObjectsArray:(NSArray *)objectsArray {
    
    if (![objectsArray count]) return;
    
    [self.bannerObjectArray removeAllObjects];
    [self.bannerObjectArray addObjectsFromArray:objectsArray];
    
    self.bannerItemCount = 0;
    NSInteger i = 0;
    
     // Ziqi Tricky Pay attention
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    
    
    Object *lastObject = [objectsArray lastObject];
    WEBannerItemView *firstItemView = [self addItemViewWithModelObject:lastObject];
    firstItemView.tag = i;
    [firstItemView addGestureRecognizer:tapGestureRecognizer];
    i++;
    
    for (Object *object in objectsArray) {
        WEBannerItemView *itemView = [self addItemViewWithModelObject:object];
        itemView.tag = i;
        [itemView addGestureRecognizer:tapGestureRecognizer];
        i++;
    }
    
    Object *firstObject = [objectsArray objectAtIndex:0];
    WEBannerItemView *lastItemView = [self addItemViewWithModelObject:firstObject];
    lastItemView.tag = i;
    [lastItemView addGestureRecognizer:tapGestureRecognizer];
    
    self.pageControl.numberOfPages -= 2;
    self.pageControl.currentPage = 0;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView)
        [self updateBannerPateControl];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        if (scrollView == self.scrollView) {
            [self updateBannerPateControl];
        }
    }
}

#pragma mark - Gesture recognizer

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tap {
    NSInteger itemIndex = tap.view.tag;
    Object *bannerObject = self.bannerObjectArray[itemIndex];
    //[self.delegate bannerContainerView:self didSelectModelObject:bannerObject];
}

@end
