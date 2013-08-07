//
//  WTBillboardDetailHeaderView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-24.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBillboardDetailHeaderView.h"
#import "BillboardPost+Addition.h"
#import "User+Addition.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AsyncLoading.h"
#import "OHAttributedLabel.h"
#import "NSString+WTAddition.h"

@interface WTBillboardDetailHeaderView ()

@property (nonatomic, weak) BillboardPost *post;
@property (nonatomic, weak) WTBillboardDetailAuthorView *authorView;

@end

@implementation WTBillboardDetailHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (WTBillboardDetailHeaderView *)createDetailHeaderViewWithBillboardPost:(BillboardPost *)post {
    WTBillboardDetailHeaderView *result = [[WTBillboardDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 320.0f)];
    result.autoresizingMask = UIViewAutoresizingNone;
    
    result.post = post;
    
    [result configurePostContentView];
    [result configureAuthorView];
    
    [result resetHeight:result.authorView.frame.size.height + result.authorView.frame.origin.y];
    
    return result;
}

- (void)configurePostContentView {
    if (self.post.image) {
        WTImageBillboardDetailHeaderView *postContentView = [WTImageBillboardDetailHeaderView createDetailHeaderView];
        [postContentView configureViewWithBillboardPost:self.post];
        self.postContentView = postContentView;
    } else {
        WTPlainTextBillboardDetailHeaderView *postContentView = [WTPlainTextBillboardDetailHeaderView createDetailHeaderView];
        [postContentView configureViewWithBillboardPost:self.post];
        self.postContentView = postContentView;
    }
    [self addSubview:self.postContentView];
}

- (void)configureAuthorView {
    self.authorView = [WTBillboardDetailAuthorView createAuthorView];
    [self.authorView configureViewWithBillboardPost:self.post];
    
    [self.authorView resetOriginY:self.postContentView.frame.size.height];
    [self addSubview:self.authorView];
}

@end

@implementation WTImageBillboardDetailHeaderView

+ (WTImageBillboardDetailHeaderView *)createDetailHeaderView {
    WTImageBillboardDetailHeaderView *result = nil;
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTBillboardDetailHeaderView" owner:nil options:nil];
    
    for (UIView *view in views) {
            if ([view isKindOfClass:[WTImageBillboardDetailHeaderView class]]) {
                result = (WTImageBillboardDetailHeaderView *)view;
                break;
            }
    }
    
    [result configureImageContainerView];
    
    return result;
}

- (void)configureViewWithBillboardPost:(BillboardPost *)post {
    [self.postImageView loadImageWithImageURLString:post.image];
    
    self.titleLabel.text = post.title;
    CGFloat titleLabelBottomIndent = self.frame.size.height - self.titleLabel.frame.size.height - self.titleLabel.frame.origin.y;
    [self.titleLabel sizeToFit];
    [self resetHeight:self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + titleLabelBottomIndent];
}

- (void)configureImageContainerView {
    self.postImageContainerView.layer.masksToBounds = YES;
    self.postImageContainerView.layer.cornerRadius = 6.0f;
}

@end

@implementation WTPlainTextBillboardDetailHeaderView

+ (WTPlainTextBillboardDetailHeaderView *)createDetailHeaderView {
    WTPlainTextBillboardDetailHeaderView *result = nil;
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTBillboardDetailHeaderView" owner:nil options:nil];
    
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTPlainTextBillboardDetailHeaderView class]]) {
            result = (WTPlainTextBillboardDetailHeaderView *)view;
            break;
        }
    }
    return result;
}

#define CONTENT_LABEL_TOP_INDENT    25.0f
#define CONTENT_LABEL_BOTTOM_INDENT 20.0f
#define CONTENT_LABEL_LINE_SPACING  8.0f

- (void)configureViewWithBillboardPost:(BillboardPost *)post {
    self.titleLabel.text = post.title;
    [self.titleLabel sizeToFit];
    
    NSMutableAttributedString *contentAttributedString = [NSMutableAttributedString attributedStringWithString:post.content];
    
    [contentAttributedString setAttributes:[self.contentLabel.attributedText attributesAtIndex:0 effectiveRange:NULL] range:NSMakeRange(0, contentAttributedString.length)];
    
    [contentAttributedString modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
        paragraphStyle.lineSpacing = CONTENT_LABEL_LINE_SPACING;
    }];
    
    self.contentLabel.attributedText = contentAttributedString;
    self.contentLabel.automaticallyAddLinksForType = NSTextCheckingTypeLink;
    
    CGFloat contentLabelHeight = [contentAttributedString sizeConstrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, 200000.0f)].height;
    
    [self.contentLabel resetHeight:contentLabelHeight];
    [self.contentLabel resetOriginY:self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y + CONTENT_LABEL_TOP_INDENT];
    [self resetHeight:self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + CONTENT_LABEL_BOTTOM_INDENT];
}

@end

@implementation WTBillboardDetailAuthorView

+ (WTBillboardDetailAuthorView *)createAuthorView {
    WTBillboardDetailAuthorView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTBillboardDetailHeaderView" owner:nil options:nil];
    
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTBillboardDetailAuthorView class]]) {
            result = (WTBillboardDetailAuthorView *)view;
            break;
        }
    }
    
    [result configureAvatarContainerView];
    
    return result;
}

- (void)configureViewWithBillboardPost:(BillboardPost *)post {
    self.timeLabel.text = [post.createdAt convertToYearMonthDayWeekTimeString];
    self.authorNameLabel.text = post.author.name;
    [self.avatarImageView loadImageWithImageURLString:post.author.avatar];
}

- (void)configureAvatarContainerView {
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
}

@end
