//
//  WTDetailDescriptionView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-10.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBillboardItemView.h"
#import <QuartzCore/QuartzCore.h>
#import "BillboardPost.h"
#import "UIImageView+AsyncLoading.h"
#import "OHAttributedLabel.h"
#import "UIApplication+WTAddition.h"
#import "WTBillboardViewController.h"

@interface WTBillboardItemView ()

@property (nonatomic, weak) BillboardPost *post;

@end

@implementation WTBillboardItemView

enum {
    BillboardLargeItemViewTag = 1000,
    BillboardSmallItemViewTag = 2000,
};

+ (WTBillboardItemView *)createItemView:(BOOL)large {
    int tag = large ? BillboardLargeItemViewTag : BillboardSmallItemViewTag;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTBillboardItemView" owner:self options:nil];
    for (UIView *view in views) {
        if (view.tag == tag)
            return (WTBillboardItemView *)view;
    }
    return nil;
}

+ (WTBillboardItemView *)createLargeItemView {
    return [WTBillboardItemView createItemView:YES];
}

+ (WTBillboardItemView *)createSmallItemView {
    return [WTBillboardItemView createItemView:NO];
}

- (void)didMoveToSuperview {
    self.imageContainerView.layer.masksToBounds = YES;
    self.imageContainerView.layer.cornerRadius = 6.0f;
}

- (void)configureViewWithBillboardPost:(BillboardPost *)post {
    self.post = post;
    
    if (post.image) {
        [self configureImageBillboardView];
    } else {
        [self configurePlainTextBillboardView];
    }
}

- (void)configureImageBillboardView {
    self.imageTextContainerView.hidden = NO;
    self.plainTextContainerView.hidden = YES;
    
    self.imageTitleLabel.text = self.post.title;
    
    [self.imageView loadImageWithImageURLString:self.post.image];
}

#define PLAIN_CONTENT_LABEL_LINE_SPACING    4.0f
#define PLAIN_CONTENT_LABEL_BOTTOM_INDENT   6.0f
#define PLAIN_CONTENT_LABEL_TOP_INDENT      6.0f
#define PLAIN_TITLE_LABEL_MAX_HEIGHT        46.0f

- (void)configurePlainTextBillboardView {
    self.imageTextContainerView.hidden = YES;
    self.plainTextContainerView.hidden = NO;
    
    self.plainTitleLabel.text = self.post.title;
    [self.plainTitleLabel resetWidth:self.plainContentLabel.frame.size.width];
    [self.plainTitleLabel sizeToFit];
    if (self.plainTitleLabel.frame.size.height > PLAIN_TITLE_LABEL_MAX_HEIGHT)
        [self.plainTitleLabel resetHeight:PLAIN_TITLE_LABEL_MAX_HEIGHT];
    
    if (self.post.content.length > 0) {
        NSMutableAttributedString *contentAttributedString = [NSMutableAttributedString attributedStringWithString:self.post.content];
        
        [contentAttributedString setAttributes:[self.plainContentLabel.attributedText attributesAtIndex:0 effectiveRange:NULL] range:NSMakeRange(0, contentAttributedString.length)];
        
        [contentAttributedString modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
            paragraphStyle.lineSpacing = PLAIN_CONTENT_LABEL_LINE_SPACING;
        }];
        
        self.plainContentLabel.attributedText = contentAttributedString;
        
        [self.plainContentLabel resetOriginY:self.plainTitleLabel.frame.origin.y + self.plainTitleLabel.frame.size.height + PLAIN_CONTENT_LABEL_TOP_INDENT];
        [self.plainContentLabel resetHeight:self.plainTextContainerView.frame.size.height - self.plainContentLabel.frame.origin.y - PLAIN_CONTENT_LABEL_BOTTOM_INDENT];
        
        self.plainContentLabel.automaticallyAddLinksForType = 0;
    }
}

#pragma mark - Actions

- (IBAction)didClickBgButton:(UIButton *)sender {
    [[UIApplication sharedApplication].billboardViewController showBillboardDetailViewWithBillboardPost:self.post];
}

@end
