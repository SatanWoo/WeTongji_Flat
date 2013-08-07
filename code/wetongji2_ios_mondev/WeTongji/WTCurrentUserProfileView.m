//
//  WTCurrentUserProfileView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCurrentUserProfileView.h"
#import "User+Addition.h"
#import "WTResourceFactory.h"
#import "OHAttributedLabel.h"

@interface WTCurrentUserProfileView ()

@property (nonatomic, weak) User *user;

@end

@implementation WTCurrentUserProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (WTCurrentUserProfileView *)createProfileViewWithUser:(User *)user {
    WTCurrentUserProfileView *result = [[NSBundle mainBundle] loadNibNamed:@"WTCurrentUserProfileView" owner:nil options:nil].lastObject;
    result.user = user;
    [result configureView];
    return result;
}

#pragma mark - UI methods

- (void)updateView {
    [self configureLabels];
}

- (void)configureView {
    [self configureFirstSectionView];
    [self configureSecondSectionView];
    [self configureLabels];
}

- (void)configureLabels {
    NSArray *countNumberArray = @[self.user.friendCount,
                                  self.user.scheduledActivityCount,
                                  self.user.scheduledCourseCount,
                                  self.user.likedActivityCount,
                                  self.user.likedNewsCount,
                                  self.user.likedStarCount,
                                  self.user.likedOrganizationCount,
                                  self.user.likedUserCount];
    
    NSArray *descriptionArray = @[self.user.friendCount.integerValue > 1 ? NSLocalizedString(@" Friends", nil) : NSLocalizedString(@" Friend", nil),
                                  4 > 1 ? NSLocalizedString(@" Scheduled Activities", nil) : NSLocalizedString(@" Scheduled Activity", nil),
                                  3 > 1 ? NSLocalizedString(@" Scheduled Courses", nil) : NSLocalizedString(@" Scheduled Course", nil),
                                  self.user.likedActivityCount.integerValue > 1 ? NSLocalizedString(@" Activities", nil) : NSLocalizedString(@" Activity", nil),
                                  NSLocalizedString(@" News", nil),
                                  self.user.likedStarCount.integerValue > 1 ? NSLocalizedString(@" Stars", nil) : NSLocalizedString(@" Star", nil),
                                  self.user.likedOrganizationCount.integerValue > 1 ? NSLocalizedString(@" Organizations", nil) : NSLocalizedString(@" Organization", nil),
                                  self.user.likedUserCount.integerValue > 1 ? NSLocalizedString(@" Users", nil) : NSLocalizedString(@" User", nil)];
    NSArray *labels = @[self.myFriendLabel,
                        self.myScheduledActivityLabel,
                        self.myScheduledCourseLabel,
                        self.likedActivityLabel,
                        self.likedNewsLabel,
                        self.likedStarLabel,
                        self.likedOrganizationLabel,
                        self.likedPersonLabel];
    
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

- (void)configureFirstSectionView {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.firstSectionBgImageView.image = bgImage;
    
//    UIButton *addFriendButton = [WTResourceFactory createAddFriendButtonWithTarget:self action:@selector(didClickAddFriendButton:)];
//    [addFriendButton resetOriginX:218.0f];
//    [addFriendButton resetCenterY:22.0f];
//    [self.firstSectionContianerView addSubview:addFriendButton];
}

- (void)configureSecondSectionView {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.secondSectionBgImageView.image = bgImage;
    
    self.myFavoriteDisplayLabel.text = NSLocalizedString(@"My Favorite", nil);
}

@end
