//
//  WTNewsBriefIntroductionView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-19.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNewsBriefIntroductionView.h"
#import "News+Addition.h"
#import "Organization+Addition.h"
#import "UIImageView+AsyncLoading.h"
#import <QuartzCore/QuartzCore.h>
#import "WTResourceFactory.h"
#import "UIApplication+WTAddition.h"

@interface WTNewsBriefIntroductionView ()

@property (nonatomic, weak) News *news;

@end

@implementation WTNewsBriefIntroductionView

+ (WTNewsBriefIntroductionView *)createNewsBriefIntroductionViewWithNews:(News *)news {
    
    WTNewsBriefIntroductionView *result = nil;
    
    switch (news.category.integerValue) {
        case NewsShowTypeCampusUpdate:
        case NewsShowTypeAdministrativeAffairs:
            result = [WTOfficialNewsBriefIntroductionView createOfficialNewsBriefIntroductionView];
            break;
        case NewsShowTypeClubNews:
            result = [WTClubNewsBriefIntroductionView createClubNewsBriefIntroductionView];
            break;
        case NewsShowTypeLocalRecommandation:
            result = [WTRecommendationNewsBriefIntroductionView createRecommendationNewsBriefIntroductionView];
            break;
        default:
            break;
    }
    result.news = news;
    [result configureView];
    return result;
}

- (void)configureView {
    
}

@end

@implementation WTOfficialNewsBriefIntroductionView

+ (WTOfficialNewsBriefIntroductionView *)createOfficialNewsBriefIntroductionView {
    WTOfficialNewsBriefIntroductionView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTNewsBriefIntroductionView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTOfficialNewsBriefIntroductionView class]]) {
            result = (WTOfficialNewsBriefIntroductionView *)view;
            break;
        }
    }
    return result;
}

- (void)configureView {
    self.titleLabel.text = self.news.title;
    self.publisherLabel.text = self.news.source;
    self.publishTimeLabel.text = self.news.publishDay;
    
    CGFloat titleLabelOriginalHeight = self.titleLabel.frame.size.height;
    [self.titleLabel sizeToFit];
    [self resetHeight:self.frame.size.height + self.titleLabel.frame.size.height - titleLabelOriginalHeight];
}

@end

@interface WTRecommendationNewsBriefIntroductionView () <UIActionSheetDelegate>

@property (nonatomic, weak) UIButton *bookTicketButton;

@end

@implementation WTRecommendationNewsBriefIntroductionView

+ (WTRecommendationNewsBriefIntroductionView *)createRecommendationNewsBriefIntroductionView {
    WTRecommendationNewsBriefIntroductionView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTNewsBriefIntroductionView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTRecommendationNewsBriefIntroductionView class]]) {
            result = (WTRecommendationNewsBriefIntroductionView *)view;
            break;
        }
    }
    return result;
}

- (void)configureView {
    [self configureOtherInfoView];
    
    if (self.news.hasTicket.boolValue) {
        [self configureTicketInfoView];
        [self resetHeight:self.otherInfoContainerView.frame.size.height + self.ticketInfoContainerView.frame.size.height];
        [self.otherInfoContainerView resetOriginY:self.ticketInfoContainerView.frame.size.height];
    } else {
        self.ticketInfoContainerView.hidden = YES;
        [self resetHeight:self.otherInfoContainerView.frame.size.height];
        [self.otherInfoContainerView resetOriginY:0];
    }
}

- (void)configureTicketInfoView {
    self.ticketInfoLabel.text = self.news.ticketInfo;
    
    CGFloat ticketInfoLabelHeight = self.ticketInfoLabel.frame.size.height;
    [self.ticketInfoLabel sizeToFit];
    [self.ticketInfoContainerView resetHeightByOffset:self.ticketInfoLabel.frame.size.height - ticketInfoLabelHeight];
}

- (void)configureBookTicketButton {
    if (self.news.phoneNumber) {
        UIButton *bookTicketButton = [WTResourceFactory createNormalButtonWithText:NSLocalizedString(@"Book a ticket", nil)];
        [bookTicketButton resetOriginX:10.0f];
        [bookTicketButton resetCenterY:self.locationButton.center.y];
        bookTicketButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [bookTicketButton addTarget:self action:@selector(didClickBookTicketButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.otherInfoContainerView addSubview:bookTicketButton];
        self.bookTicketButton = bookTicketButton;
    }
}

- (void)configureActivityLocationButton {
    [self.locationButton setTitle:self.news.location forState:UIControlStateNormal];
    CGFloat locationButtonHeight = self.locationButton.frame.size.height;
    CGFloat locationButtonCenterY = self.locationButton.center.y;
    CGFloat locationButtonRightBoundX = self.locationButton.frame.origin.x + self.locationButton.frame.size
    .width;
    [self.locationButton sizeToFit];
    
    CGFloat maxLocationButtonWidth = 238.0f - self.bookTicketButton.frame.size.width - self.bookTicketButton.frame.origin.x;
    if (self.locationButton.frame.size.width > maxLocationButtonWidth) {
        [self.locationButton resetWidth:maxLocationButtonWidth];
    }
    
    [self.locationButton resetHeight:locationButtonHeight];
    [self.locationButton resetCenterY:locationButtonCenterY];
    [self.locationButton resetOriginX:locationButtonRightBoundX - self.locationButton.frame.size.width];
}

- (void)configureOtherInfoView {
    if (!self.news.hasTicket.boolValue) {
        self.ticketIconImageView.hidden = YES;
        self.titleLabel.text = self.news.title;
    } else {
        self.titleLabel.text = [NSString stringWithFormat:@"    %@", self.news.title];
    }
    
    self.publisherLabel.text = self.news.source;
    self.publishTimeLabel.text = self.news.publishDay;
    
    [self configurePosterImageView];
    [self configureBookTicketButton];
    [self configureActivityLocationButton];
    
    
    CGFloat titleLabelOriginalHeight = self.titleLabel.frame.size.height;
    [self.titleLabel sizeToFit];
    [self.otherInfoContainerView resetHeight:self.otherInfoContainerView.frame.size.height + self.titleLabel.frame.size.height - titleLabelOriginalHeight];
}

- (void)configurePosterImageView {
    NSArray *imageArray = self.news.imageArray;
    if (imageArray.count > 0)
        [self.posterImageView loadImageWithImageURLString:imageArray[0]];
}

#pragma mark - Actions

- (void)didClickBookTicketButton:(UIButton *)sender {
    NSString *actionSheetTitle = [NSString stringWithFormat:@"%@%@?", NSLocalizedString(@"Call ", nil), self.news.phoneNumber];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    
    [actionSheet showFromTabBar:[UIApplication sharedApplication].rootTabBarController.tabBar];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSString *phoneURLString = [[NSString alloc] initWithFormat:@"tel://%@", self.news.phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneURLString]];
    }
}

- (void)awakeFromNib {
    self.ticketInfoLabel.layer.masksToBounds = NO;
    self.ticketInfoLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.ticketInfoLabel.layer.shadowOpacity = 0.25f;
    self.ticketInfoLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.ticketInfoLabel.layer.shadowRadius = 2.0f;
}

@end

@implementation WTClubNewsBriefIntroductionView

+ (WTClubNewsBriefIntroductionView *)createClubNewsBriefIntroductionView {
    WTClubNewsBriefIntroductionView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTNewsBriefIntroductionView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTClubNewsBriefIntroductionView class]]) {
            result = (WTClubNewsBriefIntroductionView *)view;
            break;
        }
    }
    return result;
}

- (void)configureView {
    self.titleLabel.text = self.news.title;
    self.publisherLabel.text = self.news.author.name;
    self.publishTimeLabel.text = self.news.publishDay;
    
    CGFloat titleLabelOriginalHeight = self.titleLabel.frame.size.height;
    [self.titleLabel sizeToFit];
    [self resetHeight:self.frame.size.height + self.titleLabel.frame.size.height - titleLabelOriginalHeight];
    
    [self.avatarImageView loadImageWithImageURLString:self.news.author.avatar];
}

- (void)awakeFromNib {
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
}

@end