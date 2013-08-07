//
//  WTOrganizationProfileView.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-5-16.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Organization;
@class OHAttributedLabel;

@interface WTOrganizationProfileView : UIView

@property (nonatomic, weak) IBOutlet UILabel *emailDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *adminNameDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *adminTitleDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *introDisplayDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *emailLabel;
@property (nonatomic, weak) IBOutlet UILabel *adminNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *adminTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *introLabel;
@property (nonatomic, weak) IBOutlet UIButton *emailButton;

@property (nonatomic, weak) IBOutlet OHAttributedLabel *publishedActivityLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *publishedNewsLabel;
@property (nonatomic, weak) IBOutlet UIButton *activityButton;
@property (nonatomic, weak) IBOutlet UIButton *newsButton;

@property (nonatomic, weak) IBOutlet UIImageView *firstSectionBgImageView;
@property (nonatomic, weak) IBOutlet UIImageView *secondSectionBgImageView;
@property (nonatomic, weak) IBOutlet UIView *firstSectionContianerView;
@property (nonatomic, weak) IBOutlet UIView *secondSectionContianerView;
@property (nonatomic, weak) IBOutlet UILabel *detailInformationDisplayLabel;

+ (WTOrganizationProfileView *)createProfileViewWithOrganization:(Organization *)org;

- (void)updateView;

@end
