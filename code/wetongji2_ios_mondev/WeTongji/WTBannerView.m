//
//  WTBannerContainerView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-1.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBannerView.h"
#import "UIImageView+AsyncLoading.h"
#import <QuartzCore/QuartzCore.h>
#import "Activity+Addition.h"
#import "News+Addition.h"
#import "Advertisement+Addition.h"
#import "NSString+WTAddition.h"
#import "Organization+Addition.h"

@interface WTBannerContainerView()

@property (nonatomic, strong) NSMutableArray *bannerItemViewArray;
@property (nonatomic, strong) NSMutableArray *bannerObjectArray;
@property (nonatomic, assign) NSUInteger bannerItemCount;

@property (nonatomic, assign) CGFloat originalBottomY;

@property (nonatomic, assign) CGFloat formerEnlargeRatio;

@property (nonatomic, assign) CGFloat pageControlOriginY;

@end

@implementation WTBannerContainerView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)didMoveToSuperview {
    self.originalBottomY = self.frame.origin.y + self.frame.size.height;
    self.pageControlOriginY = self.bannerPageControl.frame.origin.y;
}

#pragma mark - Public methods

- (WTBannerItemView *)itemViewAtIndex:(NSUInteger)index {
    return self.bannerItemViewArray[index];
}

- (WTBannerItemView *)currentItemView {
    if (self.bannerItemViewArray.count == 0)
        return nil;
    return [self itemViewAtIndex:self.bannerPageControl.currentPage];
}

+ (WTBannerContainerView *)createBannerContainerView {
    WTBannerContainerView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTBannerView" owner:self options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTBannerContainerView class]]) {
            result = (WTBannerContainerView *)view;
            break;
        }
    }
    return result;
}

- (void)configureBannerContainerViewHeight:(CGFloat)height {
    if (height < BANNER_VIEW_ORIGINAL_HIEHGT)
        return;
    
    CGFloat enlargeRatio = height / BANNER_VIEW_ORIGINAL_HIEHGT;
    BOOL isEnlarging = enlargeRatio > self.formerEnlargeRatio;
    self.formerEnlargeRatio = enlargeRatio;
    
    CGSize bannerViewSize = CGSizeMake(floorf(enlargeRatio * BANNER_VIEW_ORIGINAL_WIDTH), height);

    [self resetSize:bannerViewSize];
    [self resetOriginY:self.originalBottomY - bannerViewSize.height];
    [self resetCenterX:BANNER_VIEW_ORIGINAL_WIDTH / 2];
    
    [self.shadowContainerView resetHeight:bannerViewSize.height];
    
    [self.bannerPageControl resetCenterX:self.frame.size.width / 2];
    [self.bannerPageControl resetOriginY:bannerViewSize.height - BANNER_VIEW_ORIGINAL_HIEHGT + self.pageControlOriginY];
        
    self.bannerScrollView.contentSize = CGSizeMake(self.bannerScrollView.frame.size.width * self.bannerItemCount, bannerViewSize.height);
    self.bannerScrollView.contentOffset = CGPointMake(self.frame.size.width * self.bannerPageControl.currentPage, 0);
    [self.bannerScrollView resetHeight:bannerViewSize.height];
        
    for (int i = 0; i < self.bannerItemViewArray.count; i++) {
        WTBannerItemView *containerView = self.bannerItemViewArray[i];
        [containerView resetOriginX:containerView.frame.size.width * i];
        [containerView configureBannerItemViewHeight:bannerViewSize.height
                                        enlargeRatio:enlargeRatio
                                         isEnlarging:isEnlarging];
    }
}

- (WTBannerItemView *)addItemViewWithModelObject:(Object *)object {
    self.bannerItemCount = self.bannerItemCount + 1;
    NSInteger index = self.bannerItemCount - 1;
    WTBannerItemView *itemView = self.bannerItemViewArray[index];
    [itemView configureViewWithModelObject:self.bannerObjectArray[index]];
    
    return itemView;
}

- (void)reloadItemImages {
    for (WTBannerItemView *itemView in self.bannerItemViewArray) {
        if (!itemView.imageView.image) {
            [itemView.imageView loadImageWithImageURLString:itemView.imageURLString success:^(UIImage *image) {
                itemView.imageView.image = image;
            } failure:nil];
        }
    }
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
            WTBannerItemView *itemView = [self createBannerItemViewAtIndex:i];
            [self.bannerItemViewArray addObject:itemView];
            [self.bannerScrollView addSubview:itemView];
        }
    } else if (bannerItemCount < _bannerItemCount) {
        for(NSUInteger i = bannerItemCount; i < _bannerItemCount; i++) {
            WTBannerItemView *itemView = self.bannerItemViewArray[i];
            [itemView removeFromSuperview];
        }
        [self.bannerItemViewArray removeAllObjects];
    } else
        return;
    
    _bannerItemCount = bannerItemCount;
    self.bannerPageControl.numberOfPages = bannerItemCount;
    self.bannerScrollView.contentSize = CGSizeMake(self.bannerScrollView.frame.size.width * bannerItemCount, self.bannerScrollView.frame.size.height);
    
    [self.rightShadowImageView resetOrigin:CGPointMake(bannerItemCount == 0 ? self.bannerScrollView.frame.size.width : self.bannerScrollView.contentSize.width, 0)];
}

#pragma mark - UI methods

- (WTBannerItemView *)createBannerItemViewAtIndex:(NSUInteger)index {
    WTBannerItemView *result = [WTBannerItemView createBannerItemView];
    [result resetOrigin:CGPointMake(self.bannerScrollView.frame.size.width * index, 0)];
    result.backgroundColor = [UIColor clearColor];
    return result;
}

- (void)updateBannerPateControl {
    int currentPage = self.bannerScrollView.contentOffset.x / self.bannerScrollView.frame.size.width;
    self.bannerPageControl.currentPage = currentPage;
}

- (void)configureBannerWithObjectsArray:(NSArray *)objectsArray {
    [self.bannerObjectArray removeAllObjects];
    [self.bannerObjectArray addObjectsFromArray:objectsArray];
    
    self.bannerItemCount = 0;
    NSInteger i = 0;
    for (Object *object in objectsArray) {        
        WTBannerItemView *itemView = [self addItemViewWithModelObject:object];
        itemView.tag = i;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
        [itemView addGestureRecognizer:tapGestureRecognizer];
        
        i++;
    }
}

#pragma mark - Gesture recognizer

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tap {
    NSInteger itemIndex = tap.view.tag;
    Object *bannerObject = self.bannerObjectArray[itemIndex];
    [self.delegate bannerContainerView:self didSelectModelObject:bannerObject];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.bannerScrollView)
        [self updateBannerPateControl];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        if (scrollView == self.bannerScrollView) {
            [self updateBannerPateControl];
        }
    }
}

@end

@interface WTBannerItemView ()

@property (nonatomic, assign) CGFloat organizationNameLabelOriginY;
@property (nonatomic, assign) CGFloat titleLabelOriginY;

@property (nonatomic, assign) CGFloat formerOrganizationNameLabelOriginY;
@property (nonatomic, assign) CGFloat formerTitleLabelOriginY;

@end

@implementation WTBannerItemView

+ (WTBannerItemView *)createBannerItemView {
    WTBannerItemView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTBannerView" owner:self options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTBannerItemView class]]) {
            result = (WTBannerItemView *)view;
            break;
        }
    }
    return result;
}

- (void)awakeFromNib {
    self.titleLabel.layer.masksToBounds = NO;
    self.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.titleLabel.layer.shadowOpacity = 0.4f;
    self.titleLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.titleLabel.layer.shadowRadius = 2.0f;
}

- (void)configureBannerItemViewHeight:(CGFloat)height
                         enlargeRatio:(float)enlargeRatio
                          isEnlarging:(BOOL)isEnlarging {
    
    [self resetHeight:height];
    [self.imageView resetHeight:height];
    [self.labelContainerView resetHeight:height];
    
    [self.titleLabel resetCenterX:self.labelContainerView.frame.size.width / 2];
    [self.organizationNameLabel resetCenterX:self.labelContainerView.frame.size.width / 2];
    
    
    CGFloat titleLabelOriginY = self.titleLabelOriginY * enlargeRatio;
    CGFloat organizationNameLabelOriginY = self.organizationNameLabelOriginY * enlargeRatio;
    
    titleLabelOriginY = isEnlarging ? MAX(titleLabelOriginY, self.formerTitleLabelOriginY) : MIN(titleLabelOriginY, self.formerTitleLabelOriginY);
    organizationNameLabelOriginY = isEnlarging ? MAX(organizationNameLabelOriginY, self.formerOrganizationNameLabelOriginY) : MIN(organizationNameLabelOriginY, self.formerOrganizationNameLabelOriginY);
    
    [self.titleLabel resetOriginY:titleLabelOriginY];
    [self.organizationNameLabel resetOriginY:organizationNameLabelOriginY];
    
    self.formerTitleLabelOriginY = titleLabelOriginY;
    self.formerOrganizationNameLabelOriginY = organizationNameLabelOriginY;
}

- (void)configureViewWithModelObject:(Object *)object {
    if ([object isKindOfClass:[Activity class]]) {
        Activity *activity = (Activity *)object;
        self.imageURLString = activity.image;
        self.titleLabel.text = activity.what;
        self.organizationNameLabel.text = activity.author.name;
    } else if ([object isKindOfClass:[News class]]) {
        News *news = (News *)object;
        NSArray *imageArray = news.imageArray;
        if (imageArray) {
            self.imageURLString = imageArray[0];
        }
        self.titleLabel.text = news.title;
        // TODO: 根据新闻类别配置orgName
        self.organizationNameLabel.text = news.author.name;
    } else if ([object isKindOfClass:[Advertisement class]]) {
        Advertisement *ad = (Advertisement *)object;
        self.imageURLString = ad.image;
        self.titleLabel.text = ad.title;
        self.organizationNameLabel.text = ad.publisher;
        self.labelContainerView.backgroundColor = [ad.bgColorHex converHexStringToColorWithAlpha:0.6f];
    }
    
    CGPoint titleLabelCenter = self.titleLabel.center;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = titleLabelCenter;
    [self.organizationNameLabel resetOriginY:self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y];
    
    self.organizationNameLabelOriginY = self.organizationNameLabel.frame.origin.y;
    self.titleLabelOriginY = self.titleLabel.frame.origin.y;
    
    [self.imageView loadImageWithImageURLString:self.imageURLString];
}

@end
