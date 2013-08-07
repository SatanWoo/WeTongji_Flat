//
//  WTHomeSelectItemView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WTHomeSelectItemView.h"
#import "WTResourceFactory.h"
#import "WTLikeButtonView.h"
#import "UIImageView+AsyncLoading.h"
#import "NSString+WTAddition.h"
#import "Event+Addition.h"
#import "Activity+Addition.h"
#import "News+Addition.h"
#import "Star+Addition.h"
#import "Organization+Addition.h"

typedef enum {
    WTHomeSelectItemStyleNormal,
    WTHomeSelectItemStyleWithImage,
} WTHomeSelectItemStyle;

@interface WTHomeSelectItemView()

@property (nonatomic, strong) WTLikeButtonView *likeButtonView;
@property (nonatomic, assign) WTHomeSelectItemStyle itemStyle;

@end

@implementation WTHomeSelectItemView

- (void)updateItemViewWithInfoObject:(Object *)infoObject {
    
}

#pragma mark - Actions

- (void)didClickLikeButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark - UI methods

- (void)createShowCategoryButton {
    UIButton *showCategoryButton = nil;
    switch (self.itemStyle) {
        case WTHomeSelectItemStyleNormal: {
            showCategoryButton = [WTResourceFactory createNormalButtonWithText:NSLocalizedString(@"Show Category", nil)];
        }
            break;
         
        case WTHomeSelectItemStyleWithImage: {
            showCategoryButton = [WTResourceFactory createTranslucentButtonWithText:NSLocalizedString(@"Show Category", nil)];
        }
            break;
        default:
            break;
    }
    
    [showCategoryButton resetOrigin:CGPointMake(self.frame.size.width - showCategoryButton.frame.size.width - 8, -3)];
    self.showCategoryButton = showCategoryButton;
}

- (void)createLikeButtonViewWithTargetObject:(LikeableObject *)targetObject {
    WTLikeButtonView *likeButtonView = [WTLikeButtonView createLikeButtonViewWithObject:targetObject];
    [likeButtonView resetOrigin:CGPointMake(242.0f, -1.0f)];
    self.likeButtonView = likeButtonView;
}

@end

@implementation WTHomeSelectNewsView

+ (WTHomeSelectNewsView *)createHomeSelectNewsView:(News *)news {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"WTHomeSelectItemView" owner:self options:nil];
    WTHomeSelectNewsView *result = nil;
    for(UIView *view in viewArray) {
        if ([view isKindOfClass:[WTHomeSelectNewsView class]])
            result = (WTHomeSelectNewsView *)view;
    }
    
    [result configureViewWithNews:news];
    
    return result;
}

- (void)updateItemViewWithInfoObject:(Object *)infoObject {
    News *news = (News *)infoObject;
    NSArray *newsImageArray = news.imageArray;
    if (newsImageArray && newsImageArray.count > 0 && self.bgImageView.image == nil) {
        [self.bgImageView loadImageWithImageURLString:newsImageArray[0]];
    }
}

- (void)configureViewWithNews:(News *)news {
    // Bg image
    NSArray *newsImageArray = news.imageArray;
    self.itemStyle = (newsImageArray.count == 0) ? WTHomeSelectItemStyleNormal : WTHomeSelectItemStyleWithImage;
    if (self.itemStyle == WTHomeSelectItemStyleWithImage) {
        self.bgImageContainerView.hidden = NO;
        self.subCategoryLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        self.newsTitleLabel.textColor = [UIColor whiteColor];
        self.newsTitleLabel.shadowColor = [UIColor blackColor];
        [self configureBgImageView:newsImageArray[0]];
    } else {
        self.bgImageContainerView.hidden = YES;
        self.subCategoryLabel.shadowColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.6f];
        self.newsTitleLabel.textColor = [UIColor colorWithRed:55 / 255.0f green:55 / 255.0f blue:55 / 255.0f alpha:1.0f];
        self.newsTitleLabel.shadowColor = [UIColor clearColor];
    }
    
    // Info
    self.newsTitleLabel.text = news.title;
    
    self.subCategoryLabel.text = news.categoryString;
    
    [self createShowCategoryButton];
    [self addSubview:self.showCategoryButton];
}

- (void)configureBgImageView:(NSString *)imageURL {
    self.bgImageContainerView.layer.masksToBounds = YES;
    self.bgImageContainerView.layer.cornerRadius = 8.0f;
    
    [self.bgImageView loadImageWithImageURLString:imageURL];
}

@end

@implementation WTHomeSelectNewsWithTicketView

+ (WTHomeSelectNewsWithTicketView *)createHomeSelectNewsWithTicketView:(News *)news {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"WTHomeSelectItemView" owner:self options:nil];
    WTHomeSelectNewsWithTicketView *result = nil;
    for(UIView *view in viewArray) {
        if ([view isKindOfClass:[WTHomeSelectNewsWithTicketView class]])
            result = (WTHomeSelectNewsWithTicketView *)view;
    }
    
    [result configureViewWithNews:news];
    
    return result;
}

- (void)updateItemViewWithInfoObject:(Object *)infoObject {
    News *news = (News *)infoObject;
    NSArray *newsImageArray = news.imageArray;
    if (newsImageArray && newsImageArray.count > 0 && self.posterImageView.image == nil) {
        [self.posterImageView loadImageWithImageURLString:newsImageArray[0]];
    }
}

- (void)configureViewWithNews:(News *)news {
    // Poster image
    NSArray *newsImageArray = news.imageArray;
    if (newsImageArray) {
        [self.posterImageView loadImageWithImageURLString:newsImageArray[0]];
    }
    
    // Info
    if (news.hasTicket.boolValue) {
        self.newsTitleLabel.text = [NSString stringWithFormat:@"     %@", news.title];
    } else {
        self.newsTitleLabel.text = news.title;
        self.ticketIconImageView.hidden = YES;
    }
    
    self.timeLabel.text = news.publishDay;
    
    self.subCategoryLabel.text = news.categoryString;
    
    [self createShowCategoryButton];
    [self addSubview:self.showCategoryButton];
}

@end

@implementation WTHomeSelectStarView

+ (WTHomeSelectStarView *)createHomeSelectStarViewWithStar:(Star *)star {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"WTHomeSelectItemView" owner:self options:nil];
    WTHomeSelectStarView *result = nil;
    for(UIView *view in viewArray) {
        if ([view isKindOfClass:[WTHomeSelectStarView class]])
            result = (WTHomeSelectStarView *)view;
    }
    [result configureViewWithStar:star];
    return result;
}

- (void)updateItemViewWithInfoObject:(Object *)infoObject {
    Star *star = (Star *)infoObject;
    if (star.avatar && self.avatarImageView.image == nil) {
        [self.avatarImageView loadImageWithImageURLString:star.avatar];
    }    
}

- (void)configureViewWithStar:(Star *)star {
    [self configureAvatarImageView];
    [self createShowCategoryButton];
    [self addSubview:self.showCategoryButton];
    
    [self.avatarImageView loadImageWithImageURLString:star.avatar];
    self.nameLabel.text = star.name;
    self.titleLbale.text = star.jobTitle;
    self.subCategoryLabel.text = NSLocalizedString(@"Star", nil);
}

- (void)configureAvatarImageView {
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
}

@end

@implementation WTHomeSelectOrganizatioinView

+ (WTHomeSelectOrganizatioinView *)createHomeSelectOrganizationViewWithStar:(Organization *)org {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"WTHomeSelectItemView" owner:self options:nil];
    WTHomeSelectOrganizatioinView *result = nil;
    for(UIView *view in viewArray) {
        if ([view isKindOfClass:[WTHomeSelectOrganizatioinView class]])
            result = (WTHomeSelectOrganizatioinView *)view;
    }
    [result configureViewWithOrganization:org];
    return result;
}

- (void)updateItemViewWithInfoObject:(Object *)infoObject {
    Organization *org = (Organization *)infoObject;
    if (org.avatar && self.avatarImageView.image == nil) {
        [self.avatarImageView loadImageWithImageURLString:org.avatar];
    }
    
    [self.likeButtonView configureViewWithObject:org];
}

- (void)configureViewWithOrganization:(Organization *)org {
    [self configureAvatarImageView];
    [self createLikeButtonViewWithTargetObject:org];
    [self addSubview:self.likeButtonView];
    
    [self.avatarImageView loadImageWithImageURLString:org.avatar];
    self.nameLabel.text = org.name;
    self.aboutLabel.text = org.about;
    self.subCategoryLabel.text = NSLocalizedString(@"Organization", nil);
    
    // self.likeButtonView.likeButton.selected = !org.canLike.boolValue;
    // [self.likeButtonView setLikeCount:org.likeCount.integerValue];
}

- (void)configureAvatarImageView {
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
}

@end

@implementation WTHomeSelectActivityView

+ (WTHomeSelectActivityView *)createHomeSelectActivityView:(Activity *)activity {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"WTHomeSelectItemView" owner:self options:nil];
    WTHomeSelectActivityView *result = nil;
    for(UIView *view in viewArray) {
        if ([view isKindOfClass:[WTHomeSelectActivityView class]])
            result = (WTHomeSelectActivityView *)view;
    }
    
    [result configureViewWithActivity:activity];
    
    return result;
}

- (void)updateItemViewWithInfoObject:(Object *)infoObject {
    Activity *activity = (Activity *)infoObject;
    if (activity.image && self.posterImageView.image == nil) {
        [self.posterImageView loadImageWithImageURLString:activity.image];
    }
}

- (void)configureViewWithActivity:(Activity *)activity {
    self.titleLabel.text = activity.what;
    self.timeLabel.text = activity.yearMonthDayBeginToEndTimeString;
    self.subCategoryLabel.text = activity.categoryString;
    [self configurePosterImageView:activity.image];
    
    [self createShowCategoryButton];
    [self addSubview:self.showCategoryButton];
}

- (void)configurePosterImageView:(NSString *)imageURL {
    [self.posterImageView loadImageWithImageURLString:imageURL];
}

@end
