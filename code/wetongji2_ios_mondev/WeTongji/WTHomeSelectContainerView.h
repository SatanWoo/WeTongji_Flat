//
//  WTHomeSelectContainerView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WTHomeSelectContainerViewCategoryNews,
    WTHomeSelectContainerViewCategoryFeatured,
    WTHomeSelectContainerViewCategoryActivity,
} WTHomeSelectContainerViewCategory;

@protocol WTHomeSelectContainerViewDelegate;

#pragma mark - WTHomeSelectContainerView Interface

@interface WTHomeSelectContainerView : UIView

@property (nonatomic, weak) IBOutlet UILabel *categoryLabel;
@property (nonatomic, weak) IBOutlet UIButton *seeAllButton;
@property (nonatomic, weak) IBOutlet UIView *seeAllButtonContainerView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) id <WTHomeSelectContainerViewDelegate> delegate;
@property (nonatomic, assign) WTHomeSelectContainerViewCategory category;

- (IBAction)didClickSeeAllButton:(UIButton *)sender;

+ (WTHomeSelectContainerView *)createHomeSelectContainerViewWithCategory:(WTHomeSelectContainerViewCategory)category;

- (void)configureItemInfoArray:(NSArray *)infoArray;

- (void)updateItemViews;

@end

#pragma mark - WTHomeSelectContainerViewDelegate Protocol

@class Object;

@protocol WTHomeSelectContainerViewDelegate <NSObject>

- (void)homeSelectContainerViewDidClickSeeAllButton:(WTHomeSelectContainerView *)containerView;

- (void)homeSelectContainerView:(WTHomeSelectContainerView *)containerView
           didSelectModelObject:(Object *)modelObject;

- (void)homeSelectContainerView:(WTHomeSelectContainerView *)containerView
     didClickShowCategoryButton:(UIButton *)sender
                    modelObject:(Object *)modelObject;

@end

