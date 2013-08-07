//
//  WTStarHeaderView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-6-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTStarHeaderView.h"
#import "Star+Addition.h"
#import "UIImageView+AsyncLoading.h"
#import "WTDetailImageViewController.h"
#import "NSString+WTAddition.h"
#import <QuartzCore/QuartzCore.h>

@interface WTStarHeaderView ()

@property (nonatomic, weak) Star *star;

@end

@implementation WTStarHeaderView

#pragma mark - Factory methods

+ (WTStarHeaderView *)createHeaderViewWithStar:(Star *)star {
    WTStarHeaderView *result = [[NSBundle mainBundle] loadNibNamed:@"WTStarHeaderView" owner:nil options:nil].lastObject;
    result.star = star;
    [result configureView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:result action:@selector(didTagAvatarImageView:)];
    [result.avatarContainerView addGestureRecognizer:tapGestureRecognizer];
    
    return result;
}

#pragma mark - UI methods 

- (void)configureView {
    [self configureBackgroundColor];
    [self configureAvatarImageView];
    [self configureStarNameLabel];
    [self configureVolumeLabel];
    [self configureMottoLabel];
    [self configureViewSize];
}

- (void)configureVolumeLabel {
    self.volumeLabel.text = [NSString volumeStringForVolumeNumber:self.star.volume];
}

- (void)configureViewSize {
    CGFloat bottomIndent = self.avatarContainerView.superview.frame.origin.y + 20.0f;
    CGFloat avatarRootContainerViewBottomLine = self.avatarContainerView.superview.frame.origin.y + self.avatarContainerView.superview.frame.size.height;
    CGFloat mottoLabelBottomLine = self.mottoLabel.frame.origin.y + self.mottoLabel.frame.size.height;
    CGFloat bottomLine = fmaxf(avatarRootContainerViewBottomLine, mottoLabelBottomLine) + bottomIndent;
    [self resetHeight:bottomLine];
}

- (void)configureBackgroundColor {
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTGrayPanel"]];
}

- (void)configureStarNameLabel {
    self.starNameLabel.text = self.star.name;
    [self.starNameLabel sizeToFit];
}

- (void)configureAvatarImageView {
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
    
    [self.avatarImageView loadImageWithImageURLString:self.star.avatar];
}

#define MOTTO_LABEL_MAX_HEIGHT 57.0f

- (void)configureMottoLabel {
    if (self.star.motto) {
        self.mottoLabel.text = [NSString stringWithFormat:@"“%@”", self.star.motto];
    } else {
        self.mottoLabel.text = nil;
    }
    
    [self.mottoLabel sizeToFit];
    
    [self.mottoLabel resetHeight:self.mottoLabel.frame.size.height > MOTTO_LABEL_MAX_HEIGHT ? MOTTO_LABEL_MAX_HEIGHT : self.mottoLabel.frame.size.height];
    [self.mottoLabel resetOriginY:self.starNameLabel.frame.size.height + self.starNameLabel.frame.origin.y + (self.starNameLabel.frame.size.height == 0 ? 0 : 12.0f)];
}

#pragma mark - Gesture recognizer handler

- (void)didTagAvatarImageView:(UIGestureRecognizer *)gesture {
    UIImageView *currentImageView = self.avatarImageView;
    CGRect imageViewFrame = [self.superview.superview convertRect:currentImageView.frame fromView:currentImageView.superview];
    imageViewFrame.origin.y += 64.0f;
    
    [WTDetailImageViewController showDetailImageViewWithImageURLString:self.star.avatar
                                                         fromImageView:currentImageView
                                                              fromRect:imageViewFrame
                                                              delegate:nil];
}

@end
