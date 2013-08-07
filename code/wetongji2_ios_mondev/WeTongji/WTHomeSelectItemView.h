//
//  WTHomeSelectItemView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class News;
@class Activity;
@class Star;
@class Organization;
@class LikeableObject;
@interface WTHomeSelectItemView : UIView

@property (nonatomic, weak) IBOutlet UILabel *subCategoryLabel;
@property (nonatomic, weak) IBOutlet UIView *bgImageContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UIButton *bgButton;
@property (nonatomic, weak) IBOutlet UIButton *bgCoverButton;
@property (nonatomic, strong) UIButton *showCategoryButton;

- (void)updateItemViewWithInfoObject:(LikeableObject *)infoObject;

@end

@interface WTHomeSelectNewsView : WTHomeSelectItemView

@property (nonatomic, weak) IBOutlet UILabel *newsTitleLabel;

+ (WTHomeSelectNewsView *)createHomeSelectNewsView:(News *)news;

@end

@interface WTHomeSelectNewsWithTicketView : WTHomeSelectItemView

@property (nonatomic, weak) IBOutlet UILabel *newsTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *posterImageView;
@property (nonatomic, weak) IBOutlet UIImageView *ticketIconImageView;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

+ (WTHomeSelectNewsWithTicketView *)createHomeSelectNewsWithTicketView:(News *)news;

@end

@interface WTHomeSelectStarView : WTHomeSelectItemView

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIView *avatarContainerView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLbale;

+ (WTHomeSelectStarView *)createHomeSelectStarViewWithStar:(Star *)star;

@end

@interface WTHomeSelectOrganizatioinView : WTHomeSelectItemView

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIView *avatarContainerView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *aboutLabel;

+ (WTHomeSelectOrganizatioinView *)createHomeSelectOrganizationViewWithStar:(Organization *)org;

@end

@interface WTHomeSelectActivityView : WTHomeSelectItemView

@property (nonatomic, weak) IBOutlet UIImageView *posterImageView;
@property (nonatomic, weak) IBOutlet UIView *posterContainerView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

+ (WTHomeSelectActivityView *)createHomeSelectActivityView:(Activity *)activity;

@end
