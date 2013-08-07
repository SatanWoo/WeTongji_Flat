//
//  WTCurrentUserProfileView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class OHAttributedLabel;

@interface WTCurrentUserProfileView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *firstSectionBgImageView;
@property (nonatomic, weak) IBOutlet UIImageView *secondSectionBgImageView;
@property (nonatomic, weak) IBOutlet UIView *firstSectionContianerView;
@property (nonatomic, weak) IBOutlet UIView *secondSectionContianerView;
@property (nonatomic, weak) IBOutlet UILabel *myFavoriteDisplayLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *myFriendLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *myScheduledActivityLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *myScheduledCourseLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *likedActivityLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *likedNewsLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *likedStarLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *likedOrganizationLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *likedPersonLabel;
@property (nonatomic, weak) IBOutlet UIButton *likedActiviyButton;
@property (nonatomic, weak) IBOutlet UIButton *likedNewsButton;
@property (nonatomic, weak) IBOutlet UIButton *likedOrganizationButton;
@property (nonatomic, weak) IBOutlet UIButton *likedStarButton;
@property (nonatomic, weak) IBOutlet UIButton *likedUserButton;
@property (nonatomic, weak) IBOutlet UIButton *friendButton;
@property (nonatomic, weak) IBOutlet UIButton *scheduledActivityButton;
@property (nonatomic, weak) IBOutlet UIButton *scheduledCourseButton;

+ (WTCurrentUserProfileView *)createProfileViewWithUser:(User *)user;

- (void)updateView;

@end
