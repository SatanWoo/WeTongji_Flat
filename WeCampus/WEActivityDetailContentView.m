//
//  WEActivityDetailContentView.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-15.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEActivityDetailContentView.h"
#import "WTActivityImageRollView.h"
#import <OHAttributedLabel.h>

@interface WEActivityDetailContentView()
@property (strong, nonatomic) WTActivityImageRollView *imageRollView;
@end

@implementation WEActivityDetailContentView

+ (WEActivityDetailContentView *)createDetailContentViewWithInfo:(Activity *)act
{
     WEActivityDetailContentView *view = [[[NSBundle mainBundle] loadNibNamed:@"WEActivityDetailContentView" owner:nil options:nil] lastObject];
    
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

- (void)configureContentWithInfo:(Activity *)act
{
    if (act.image) {
        self.imageRollView = [WTActivityImageRollView createImageRollViewWithImageURLStringArray:@[act.image]];
        [self insertSubview:self.imageRollView atIndex:0];
    }
    
    [self configureContentLabel:act.content];
    
    if (self.imageRollView) {
        [self.contentLabel resetOriginY:self.imageRollView.frame.origin.y + self.imageRollView.frame.size.height];
    }

    [self resetHeight:self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height];
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
    //[self.contentLabel sizeToFit];
    
    [self.contentLabel resetHeight:contentLabelHeight];
    
    self.contentLabel.automaticallyAddLinksForType = NSTextCheckingTypeLink;
}


@end
