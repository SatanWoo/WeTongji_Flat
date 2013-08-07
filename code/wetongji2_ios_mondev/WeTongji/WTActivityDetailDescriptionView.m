//
//  WTDetailDescriptionView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-10.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTActivityDetailDescriptionView.h"
#import "Activity+Addition.h"
#import "Organization+Addition.h"
#import "OHAttributedLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AsyncLoading.h"

@implementation WTActivityDetailDescriptionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (WTActivityDetailDescriptionView *)createDetailDescriptionViewWithActivity:(Activity *)activity {
    WTActivityDetailDescriptionView *result = [[[NSBundle mainBundle] loadNibNamed:@"WTActivityDetailDescriptionView" owner:self options:nil] lastObject];
    
    [result configureViewWithActivity:activity];
    
    return result;
}

#pragma mark - UI methods

#define DETAIL_VIEW_BOTTOM_INDENT   10.0f

- (void)configureViewWithActivity:(Activity *)activity {
    [self configureOrganizerDisplayLabelAndButton:activity.author.name];
    [self configureContentView:activity.content];
    [self configureOrganizerAvatar:activity.author.avatar];
    
    [self resetHeight:self.contentContainerView.frame.origin.y + self.contentContainerView.frame.size.height + DETAIL_VIEW_BOTTOM_INDENT];
}

#define CONTENT_LABEL_LINE_SPACING 6.0f

- (void)configureOrganizerDisplayLabelAndButton:(NSString *)organizerName {
    self.organizerDisplayLabel.text = NSLocalizedString(@"Organizer", nil);
    [self.organizerButton setTitle:organizerName forState:UIControlStateNormal];
}

- (void)configureContentView:(NSString *)content {
    [self configureContentLabel:content];
    [self configureContentViewBgImageView];
}

- (void)configureContentLabel:(NSString *)content {
    self.aboutDisplayLabel.text = NSLocalizedString(@"About", nil);
    

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

- (void)configureContentViewBgImageView {
    UIImage *roundCornerPanelImage = [[UIImage imageNamed:@"WTRoundCornerPanelBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(50.0f, 50.0f, 50.0f, 50.0f)];
    UIImageView *aboutImageContainer = [[UIImageView alloc] initWithImage:roundCornerPanelImage];
    [aboutImageContainer resetSize:CGSizeMake(self.contentContainerView.frame.size.width, 60.0 + self.contentLabel.frame.size.height)];
    [aboutImageContainer resetOrigin:CGPointZero];
    
    [self.contentContainerView insertSubview:aboutImageContainer atIndex:0];
    [self.contentContainerView resetHeight:aboutImageContainer.frame.size.height];
}

- (void)configureOrganizerAvatar:(NSString *)avatarURL {
    self.organizerAvatarContainerView.layer.masksToBounds = YES;
    self.organizerAvatarContainerView.layer.cornerRadius = 3.0f;
    
    [self.organizerAvatarImageView loadImageWithImageURLString:avatarURL];
}

@end
