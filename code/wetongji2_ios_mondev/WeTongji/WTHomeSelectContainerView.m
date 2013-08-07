//
//  WTHomeSelectContainerView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTHomeSelectContainerView.h"
#import "WTHomeSelectItemView.h"
#import "News+Addition.h"
#import "Activity+Addition.h"
#import "Star+Addition.h"
#import "Organization+Addition.h"

@interface WTHomeSelectContainerView()

@property (nonatomic, strong) NSMutableArray *itemInfoArray;
@property (nonatomic, strong) NSMutableArray *itemViewArray;

@end

@implementation WTHomeSelectContainerView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.itemViewArray = [NSMutableArray array];
    }
    return self;
}

- (void)didMoveToSuperview {
    [self configureSeeAllButton];
    [self configureScrollView];
}

+ (WTHomeSelectContainerView *)createHomeSelectContainerViewWithCategory:(WTHomeSelectContainerViewCategory)category {
    WTHomeSelectContainerView *result = [[[NSBundle mainBundle] loadNibNamed:@"WTHomeSelectContainerView" owner:self options:nil] lastObject];
    result.category = category;
    switch (category) {
        case WTHomeSelectContainerViewCategoryNews:
        {
            result.categoryLabel.text = NSLocalizedString(@"News", nil);
        }
            break;
        case WTHomeSelectContainerViewCategoryFeatured:
        {
            result.categoryLabel.text = NSLocalizedString(@"Featured", nil);
        }
            break;
        case WTHomeSelectContainerViewCategoryActivity:
        {
            result.categoryLabel.text = NSLocalizedString(@"Activity", nil);
        }
            break;
        default:
            break;
    }

    result.itemInfoArray = [NSMutableArray array];
    
    return result;
}

- (void)configureItemInfoArray:(NSArray *)infoArray {
    [self.itemInfoArray removeAllObjects];
    [self.itemInfoArray addObjectsFromArray:infoArray];
    [self configureScrollView];
}

- (void)updateItemViews {
    NSUInteger index = 0;
    for (WTHomeSelectItemView *itemView in self.itemViewArray) {
        [itemView updateItemViewWithInfoObject:self.itemInfoArray[index]];
        index++;
    }
}

#pragma mark - Logic methods

- (NSUInteger)numberOfItemViewsInScrollView {
    return self.itemInfoArray.count;
}

- (WTHomeSelectItemView *)createItemViewAtIndex:(NSUInteger)index {
    if (index >= self.itemViewArray.count) {
        WTHomeSelectItemView *itemView = nil;
        switch (self.category) {
            case WTHomeSelectContainerViewCategoryNews: {
                News *news = self.itemInfoArray[index];
                if (news.category.integerValue == NewsShowTypeLocalRecommandation) {
                    itemView = [WTHomeSelectNewsWithTicketView createHomeSelectNewsWithTicketView:news];
                } else {
                    itemView = [WTHomeSelectNewsView createHomeSelectNewsView:news];
                }
            }
                break;
            case WTHomeSelectContainerViewCategoryFeatured: {
                
                Object *infoObject = self.itemInfoArray[index];
                
                if ([infoObject isKindOfClass:[Star class]]) {
                    itemView = [WTHomeSelectStarView createHomeSelectStarViewWithStar:(Star *)infoObject];
                } else if ([infoObject isKindOfClass:[Organization class]]) {
                    itemView = [WTHomeSelectOrganizatioinView createHomeSelectOrganizationViewWithStar:(Organization *)infoObject];
                }
                
            }
                break;
            case WTHomeSelectContainerViewCategoryActivity: {
                itemView = [WTHomeSelectActivityView createHomeSelectActivityView:self.itemInfoArray[index]];
            }
                break;
            default:
                break;
        }
        
        itemView.bgButton.tag = index;
        itemView.bgCoverButton.tag = index;
        itemView.showCategoryButton.tag = index;
        
        [itemView.bgButton addTarget:self action:@selector(didClickItemViewBgButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [itemView.bgCoverButton addTarget:self action:@selector(didClickItemViewBgButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [itemView.showCategoryButton addTarget:self action:@selector(didClickShowCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.itemViewArray addObject:itemView];
        return itemView;
    } else {
        return (self.itemViewArray)[index];
    }
}

#pragma mark - UI methods

- (void)configureSeeAllButton {
    switch (self.category) {
        case WTHomeSelectContainerViewCategoryNews:
            [self configureSeeAllButtonWithTitle:NSLocalizedString(@"See All News", nil)];
            break;
            
        case WTHomeSelectContainerViewCategoryActivity:
            [self configureSeeAllButtonWithTitle:NSLocalizedString(@"See All Activities", nil)];
            break;
            
        case WTHomeSelectContainerViewCategoryFeatured:
            self.seeAllButtonContainerView.hidden = YES;
            break;
            
        default:
            break;
    }
    
}

- (void)configureSeeAllButtonWithTitle:(NSString *)seeAllTitle {
    [self.seeAllButton setTitle:seeAllTitle forState:UIControlStateNormal];
    CGFloat seeAllButtonHeight = self.seeAllButton.frame.size.height;
    CGFloat seeAllButtonCenterY = self.seeAllButton.center.y;
    CGFloat seeAllButtonRightBoundX = self.seeAllButton.frame.origin.x + self.seeAllButton.frame.size.width;
    [self.seeAllButton sizeToFit];
    [self.seeAllButton resetHeight:seeAllButtonHeight];
    [self.seeAllButton resetCenterY:seeAllButtonCenterY];
    [self.seeAllButton resetOriginX:seeAllButtonRightBoundX - self.seeAllButton.frame.size.width];
}

- (void)clearItemViewArray {
    for (UIView *view in self.itemViewArray) {
        [view removeFromSuperview];
    }
    [self.itemViewArray removeAllObjects];
}

- (void)configureScrollView {
    [self clearItemViewArray];
    for(NSUInteger i = 0; i < [self numberOfItemViewsInScrollView]; i++) {
        WTHomeSelectItemView *itemView = [self createItemViewAtIndex:i];
        [self.scrollView addSubview:itemView];
    }
    self.scrollView.alwaysBounceHorizontal = YES;
    [self layoutScrollView];
}

- (void)layoutScrollView {
    CGFloat scrollViewContentWidth = self.scrollView.frame.size.width * [self numberOfItemViewsInScrollView];
    self.scrollView.contentSize = CGSizeMake(scrollViewContentWidth, self.scrollView.frame.size.height);
    
    for(NSUInteger i = 0; i < [self numberOfItemViewsInScrollView]; i++) {
        WTHomeSelectItemView *itemView = [self createItemViewAtIndex:i];
        
        itemView.center = CGPointMake(self.scrollView.frame.size.width * (i + 0.5f), self.scrollView.frame.size.height / 2);
    }
    
    self.scrollView.contentOffset = CGPointMake(-self.scrollView.contentInset.left, 0);
}

#pragma mark - Actions

- (void)didClickSeeAllButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeSelectContainerViewDidClickSeeAllButton:)]) {
        [self.delegate homeSelectContainerViewDidClickSeeAllButton:self];
    }
}

- (void)didClickItemViewBgButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeSelectContainerView:didSelectModelObject:)]) {
        [self.delegate homeSelectContainerView:self didSelectModelObject:self.itemInfoArray[sender.tag]];
    }
}

- (void)didClickShowCategoryButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeSelectContainerView:didClickShowCategoryButton:modelObject:)]) {
        [self.delegate homeSelectContainerView:self didClickShowCategoryButton:sender modelObject:self.itemInfoArray[sender.tag]];
    }
}

@end
