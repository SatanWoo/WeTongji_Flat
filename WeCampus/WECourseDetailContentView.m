//
//  WEActivityDetailContentView.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-15.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WECourseDetailContentView.h"
#import "WECourseDetailControlAreaView.h"
#import <OHAttributedLabel.h>

@interface WECourseDetailContentView()
@property (strong, nonatomic) WECourseDetailControlAreaView *controlAreaView;
@property (strong, nonatomic) WECourseDetailControlAreaView *bottomAreaView;
@end

@implementation WECourseDetailContentView

+ (WECourseDetailContentView *)createDetailContentViewWithInfo:(Course *)act
{
     WECourseDetailContentView *view = [[[NSBundle mainBundle] loadNibNamed:@"WECourseDetailContentView" owner:nil options:nil] lastObject];
    
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

- (void)resetLayout:(CGFloat)percent
{
    if (percent < 0) return;
    if (percent > 1) percent = 1;
    
    self.controlAreaView.alpha = 1 - percent;
}

#define kSpan 20
- (void)configureContentWithInfo:(Course *)act
{
    [self configureControlArea:act];
    
    //[self configureContentLabel:act.content];
    
    [self.contentLabel resetOriginY:self.controlAreaView.frame.origin.y + self.controlAreaView.frame.size.height + kSpan / 2];
    
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

- (void)configureControlArea:(Course *)act
{
    self.controlAreaView = [WECourseDetailControlAreaView createCourseDetailViewWithInfo:act];
    [self.controlAreaView resetOriginY:0];
    [self addSubview:self.controlAreaView];
}

#define kBigSpan 25
- (void)configureBottomControlArea:(Course *)act
{
    self.bottomAreaView = [WECourseDetailControlAreaView createCourseDetailViewWithInfo:act];
    [self.bottomAreaView resetOriginY:self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + kBigSpan];
    [self addSubview:self.bottomAreaView];
}


@end
