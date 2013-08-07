//
//  WTUserProfileHeaderView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-12.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTUserProfileHeaderView.h"
#import "User+Addition.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AsyncLoading.h"
#import "UIImage+StackBlur.h"
#import "WTCoreDataManager.h"
#import "WTDetailImageViewController.h"

@interface WTUserProfileHeaderView ()

@property (nonatomic, weak) User *user;

@end

@implementation WTUserProfileHeaderView

- (void)configureAvatarImageView {
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
    
    User *user = self.user;
    [self.avatarImageView loadImageWithImageURLString:user.avatar success:^(UIImage *image) {
        self.avatarImageView.image = image;
        [self.avatarImageView fadeIn];
        [self configureAvatarBgImageViewWithAvatarImage:image completion:^(UIImage *bgImage) {
            self.avatarBgImageView.image = bgImage;
            [self.avatarBgImageView fadeIn];
        }];
    } failure:nil];
}

#define MOTTO_LABEL_MAX_HEIGHT      57.0f
#define MOTTO_LABEL_ORIGINAL_WIDTH  200.0f

- (void)configureFunctionButton {
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    if (self.user == currentUser) {
        [self.functionButton setTitle:NSLocalizedString(@"New Avatar", nil) forState:UIControlStateNormal];
    } else {
        // 判断是否为好友
        if (![currentUser.friends containsObject:self.user]) {
            [self.functionButton setTitle:NSLocalizedString(@"Add Friend", nil) forState:UIControlStateNormal];
        } else {
            [self.functionButton setTitle:NSLocalizedString(@"Unfriend", nil) forState:UIControlStateNormal];
        }
    }
    
    for (UIView *view in self.functionButton.subviews) {
        if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
            [view removeFromSuperview];
            break;
        }
    }
    
    self.functionButton.userInteractionEnabled = YES;
}

- (void)configureGenderIndicatorImageView {
    if ([self.user.gender isEqualToString:@"男"]) {
        self.genderIndicatorImageView.image = [UIImage imageNamed:@"WTGenderWhiteMaleIcon"];
    } else {
        self.genderIndicatorImageView.image = [UIImage imageNamed:@"WTGenderWhiteFemaleIcon"];
    }
}

- (void)configureSchoolLabel {
    self.schoolLabel.text = self.user.department;
    self.schoolLabel.layer.masksToBounds = NO;
    self.schoolLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.schoolLabel.layer.shadowOpacity = 0.3f;
    self.schoolLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.schoolLabel.layer.shadowRadius = 1.0f;
}

- (void)configureUserNameLabel {
    if ([WTCoreDataManager sharedManager].currentUser != self.user) {
        self.userNameLabel.text = self.user.name;
        self.userNameLabel.layer.masksToBounds = NO;
        self.userNameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        self.userNameLabel.layer.shadowOpacity = 0.3f;
        self.userNameLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
        self.userNameLabel.layer.shadowRadius = 1.0f;
    } else {
        self.userNameLabel.text = nil;
    }
    [self.userNameLabel sizeToFit];
}

- (void)configureMottoLabel {
    [self.mottoLabel resetWidth:MOTTO_LABEL_ORIGINAL_WIDTH];
    if (self.user.motto && self.user.motto.length > 0) {
        self.mottoLabel.text = [NSString stringWithFormat:@"“%@”", self.user.motto];
        self.mottoLabel.layer.masksToBounds = NO;
        self.mottoLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        self.mottoLabel.layer.shadowOpacity = 0.3f;
        self.mottoLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
        self.mottoLabel.layer.shadowRadius = 1.0f;
    } else {
        self.mottoLabel.text = nil;
    }
    
    [self.mottoLabel sizeToFit];
    [self.mottoLabel resetHeight:self.mottoLabel.frame.size.height > MOTTO_LABEL_MAX_HEIGHT ? MOTTO_LABEL_MAX_HEIGHT : self.mottoLabel.frame.size.height];
    [self.mottoLabel resetOriginY:self.userNameLabel.frame.size.height + self.userNameLabel.frame.origin.y + (self.userNameLabel.frame.size.height == 0 ? 0 : 12.0f)];
}

#define MIN_PERSONAL_INFO_CONTAINER_VIEW_BOTTOM_INDENT  10.0f

- (void)configurePersonalInfoContainerView {
    [self configureGenderIndicatorImageView];
    [self configureSchoolLabel];
    [self.personalInfoContainerView resetOriginY:self.mottoLabel.frame.size.height + self.mottoLabel.frame.origin.y + (self.mottoLabel.frame.size.height == 0 ? 0 : 20.0f)];
    
    if (self.frame.size.height - self.personalInfoContainerView.frame.origin.y - self.personalInfoContainerView.frame.size.height < MIN_PERSONAL_INFO_CONTAINER_VIEW_BOTTOM_INDENT) {
        [self.personalInfoContainerView resetOriginY:self.frame.size.height - self.personalInfoContainerView.frame.size.height - MIN_PERSONAL_INFO_CONTAINER_VIEW_BOTTOM_INDENT];
    }
}

- (void)configureInfoView {
    [self configureFunctionButton];
    [self configureUserNameLabel];
    [self configureMottoLabel];
    [self configurePersonalInfoContainerView];
}

- (void)configureView {
    [self configureAvatarImageView];
    [self configureInfoView];
}

- (void)configureAvatarBgImageViewWithAvatarImage:(UIImage *)image
                                       completion:(void (^)(UIImage *bgImage))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *resultImage = [image stackBlur:4];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(resultImage);
            }
        });
    });
}

- (void)updateAvatarImageView {
    
    [self.avatarImageView loadImageWithImageURLString:self.user.avatar success:^(UIImage *image) {
        [self configureAvatarBgImageViewWithAvatarImage:image completion:^(UIImage *bgImage) {
            if (self.avatarBgImageView.image) {
                self.avatarBgPlaceholderImageView.image = self.avatarBgImageView.image;
            }
            self.avatarBgImageView.image = bgImage;
            [self.avatarBgImageView fadeIn];
        }];
        
        self.avatarPlaceholderImageView.image = self.avatarImageView.image;
        self.avatarImageView.image = image;
        [self.avatarImageView fadeIn];
        
    } failure:nil];
}

#pragma mark - Factory methods

+ (WTUserProfileHeaderView *)createProfileHeaderViewWithUser:(User *)user {
    WTUserProfileHeaderView *result = [[NSBundle mainBundle] loadNibNamed:@"WTUserProfileHeaderView" owner:nil options:nil].lastObject;
    result.user = user;
    [result configureView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:result action:@selector(didTagAvatarImageView:)];
    [result.avatarContainerView addGestureRecognizer:tapGestureRecognizer];
    
    return result;
}

#pragma mark - Public methods

- (void)updateView {
    [self updateAvatarImageView];
    [self configureInfoView];
}

#pragma mark - Gesture recognizer handler

- (void)didTagAvatarImageView:(UIGestureRecognizer *)gesture {
    UIImageView *currentImageView = self.avatarImageView;
    CGRect imageViewFrame = [self.superview.superview convertRect:currentImageView.frame fromView:currentImageView.superview];
    imageViewFrame.origin.y += 64.0f;
    
    [WTDetailImageViewController showDetailImageViewWithImageURLString:self.user.avatar
                                                         fromImageView:currentImageView
                                                              fromRect:imageViewFrame
                                                              delegate:nil];
}

@end
