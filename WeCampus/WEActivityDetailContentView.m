//
//  WEActivityDetailContentView.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-15.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEActivityDetailContentView.h"
#import "WTActivityImageRollView.h"
#import "WEActivityDetailControlAreaView.h"
#import "WTDetailImageViewController.h"
#import "WEInviteFriendsViewController.h"
#import <OHAttributedLabel.h>

@interface WEActivityDetailContentView() <WTDetailImageViewControllerDelegate, WEActivityDetailControlAreaViewDelegate, WEInviteFriendsViewControllerDelegate>
@property (strong, nonatomic) WTActivityImageRollView *imageRollView;
@property (strong, nonatomic) WEActivityDetailControlAreaView *controlAreaView;
@property (strong, nonatomic) WEActivityDetailControlAreaView *bottomAreaView;
@property (strong, nonatomic) Activity *act;
@property (strong, nonatomic) WEInviteFriendsViewController *inviteController;
@end

@implementation WEActivityDetailContentView

+ (WEActivityDetailContentView *)createDetailContentViewWithInfo:(Activity *)act
{
     WEActivityDetailContentView *view = [[[NSBundle mainBundle] loadNibNamed:@"WEActivityDetailContentView" owner:nil options:nil] lastObject];
    
    view.act = act;
    [view configureContentWithInfo:act];
    return view;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (UIImage *)currentImage
{
    return self.imageRollView.currentItemView.imageView.image;
}

- (void)resetLayout:(CGFloat)percent
{
    if (percent < 0) return;
    if (percent > 1) percent = 1;
    
    self.controlAreaView.alpha = 1 - percent;
}

- (void)resetNormalLayout
{
    self.controlAreaView.alpha = 1;
}

- (void)resetTransparentLayout
{
    self.controlAreaView.alpha = 0;
}


#define kSpan 20
- (void)configureContentWithInfo:(Activity *)act
{
    [self configureControlArea:act];
    
    if (act.image) {
        self.imageRollView = [WTActivityImageRollView createImageRollViewWithImageURLStringArray:@[act.image]];
        [self.imageRollView resetOriginY:self.controlAreaView.frame.origin.y + self.controlAreaView.frame.size.height];
        [self addSubview:self.imageRollView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTagImageRollView:)];
        [self.imageRollView.scrollView addGestureRecognizer:tapGestureRecognizer];
    }
    
    [self configureContentLabel:act.content];
    
    if (self.imageRollView) {
        [self.contentLabel resetOriginY:self.imageRollView.frame.origin.y + self.imageRollView.frame.size.height + kSpan];
    } else {
        [self.contentLabel resetOriginY:self.controlAreaView.frame.origin.y + self.controlAreaView.frame.size.height + kSpan / 2];
    }
    
    [self configureBottomControlArea:act];
    [self resetHeight:self.bottomAreaView.frame.origin.y + self.bottomAreaView.frame.size.height];
}

#define CONTENT_LABEL_LINE_SPACING 6.0f
- (void)configureContentLabel:(NSString *)content {
    
    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithString:content];
    
    [contentAttributedString setAttributes:[self.contentLabel.attributedText attributesAtIndex:0 effectiveRange:NULL] range:NSMakeRange(0, contentAttributedString.length)];
    
    [contentAttributedString modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
        paragraphStyle.lineSpacing = CONTENT_LABEL_LINE_SPACING;
    }];
    
    self.contentLabel.attributedText = contentAttributedString;
    
    CGFloat contentLabelHeight = [contentAttributedString sizeConstrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, 200000.0f)].height;
    
    [self.contentLabel resetHeight:contentLabelHeight];
    
    self.contentLabel.automaticallyAddLinksForType = NSTextCheckingTypeLink;
}

- (void)configureControlArea:(Activity *)act
{
    self.controlAreaView = [WEActivityDetailControlAreaView createActivityDetailViewWithInfo:act];
    self.controlAreaView.delegate = self;
    [self.controlAreaView resetOriginY:0];
    [self addSubview:self.controlAreaView];
}

#define kBigSpan 25
- (void)configureBottomControlArea:(Activity *)act
{
    self.bottomAreaView = [WEActivityDetailControlAreaView createActivityDetailViewWithInfo:act];
    self.bottomAreaView.delegate = self;
    [self.bottomAreaView resetOriginY:self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + kBigSpan];
    [self addSubview:self.bottomAreaView];
}

#pragma mark - Handle gesture methods
- (void)didTagImageRollView:(UITapGestureRecognizer *)gesture {
    WTActivityImageRollItemView *currentImageRollItemView = [self.imageRollView currentItemView];
    UIImageView *currentImageView = currentImageRollItemView.imageView;
    CGRect imageViewFrame = [self.containerViewController.view convertRect:currentImageView.frame fromView:currentImageView.superview];
    imageViewFrame.origin.y += 64.0f;
    
    [WTDetailImageViewController showDetailImageViewWithImageURLString:self.act.image
                                                         fromImageView:currentImageView
                                                              fromRect:imageViewFrame
                                                              delegate:self];
}

#pragma mark - delgate
- (void)detailImageViewControllerDidDismiss:(NSUInteger)currentPage {
    self.imageRollView.scrollView.contentOffset = CGPointMake(self.imageRollView.frame.size.width * currentPage, 0);
    self.imageRollView.pageControl.currentPage = currentPage;
    [self.imageRollView reloadItemImages];
}

#pragma mark - WEActivityDetailControlAreaViewDelegate
- (void)inviteOthers
{
    if (self.inviteController) return;
    
    self.inviteController = [WEInviteFriendsViewController
                                         createInviteFriendsViewControllerWithDelegate:self];
    [self.containerViewController.view addSubview:self.inviteController.view];
}

- (void)joinEvent
{
    
}

- (void)like
{
    
}

#pragma mark - WEInviteFriendsViewControllerDelegate
- (void)cancelInviteFriends
{
    
}

- (void)finishInviteFriends:(NSArray *)friends
{
    
}

@end
