//
//  WTOrganizationProfileView.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-5-16.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTOrganizationProfileView.h"
#import "OHAttributedLabel.h"
#import "Organization+Addition.h"

@interface WTOrganizationProfileView()

@property (nonatomic, strong) Organization *org;

@end

@implementation WTOrganizationProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (WTOrganizationProfileView *)createProfileViewWithOrganization:(Organization *)org {
    WTOrganizationProfileView *profile = [[NSBundle mainBundle]
                                          loadNibNamed:@"WTOrganizationProfileView" owner:nil options:nil].lastObject;
    profile.org = org;
    
    [profile configureView];
    
    return profile;
}

#pragma mark - Public methods

- (void)updateView {
    [self configureLabels];
    [self configureHeight];
}

#pragma mark - UI methods

#define DETAIL_VIEW_BOTTOM_INDENT   16.0f

- (void)configureLabels {
    [self configureFirstSectionLabels];
    CGFloat introLabelOrginalHeight = self.introLabel.frame.size.height;
    [self configureSecondSectionLabels];
    CGFloat introLabelHeightIncrement = self.introLabel.frame.size.height - introLabelOrginalHeight;
    [self.secondSectionContianerView resetHeightByOffset:introLabelHeightIncrement];
}

- (void)configureView {
    [self configureLabels];
    [self configureFirstSectionView];
    [self configureSecondSectionView];
    [self configureHeight];
}

- (void)configureHeight {
    [self resetHeight:self.secondSectionContianerView.frame.origin.y + self.secondSectionContianerView.frame.size.height + DETAIL_VIEW_BOTTOM_INDENT];
}

- (void)configureFirstSectionView {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.firstSectionBgImageView.image = bgImage;
}

- (void)configureFirstSectionLabels {
    NSArray *countNumberArray = @[self.org.activityCount, self.org.newsCount];
    NSArray *descriptionArray = @[self.org.activityCount.integerValue > 1 ? NSLocalizedString(@" Activities", nil) : NSLocalizedString(@" Activity", nil),
                                  NSLocalizedString(@" News", nil)];
    NSArray *labels = @[self.publishedActivityLabel,
                        self.publishedNewsLabel];
    
    for (int i = 0; i < countNumberArray.count; i++) {
        OHAttributedLabel *label = labels[i];
        NSNumber *countNumber = countNumberArray[i];
        NSString *description = descriptionArray[i];
        NSMutableAttributedString *attributedString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"%d%@", countNumber.integerValue, description]];
        [attributedString setAttributes:[label.attributedText attributesAtIndex:label.attributedText.length - 1 effectiveRange:NULL] range:NSMakeRange(0, attributedString.length)];
        [attributedString setTextBold:YES range:NSMakeRange(0, countNumber.stringValue.length)];
        label.attributedText = attributedString;
    }
}

- (void)configureSecondSectionView {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.secondSectionBgImageView.image = bgImage;
    
    self.detailInformationDisplayLabel.text = NSLocalizedString(@"Detail Information", nil);
}

- (void)configureSecondSectionLabels {
    self.adminNameDisplayLabel.text = NSLocalizedString(@"Admin Name", nil);
    self.adminTitleDisplayLabel.text = NSLocalizedString(@"Admin Title", nil);
    self.emailDisplayLabel.text = NSLocalizedString(@"Public Email", nil);
    self.introDisplayDisplayLabel.text = NSLocalizedString(@"Intro", nil);
    
    self.adminNameLabel.text = self.org.administrator;
    self.adminTitleLabel.text = self.org.adminTitle;
    self.emailLabel.text = self.org.email;
    self.introLabel.text = self.org.about;
    
    [self.introLabel sizeToFit];
}

@end
