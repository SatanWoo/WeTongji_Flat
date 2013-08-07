//
//  WTOtherUserProfileView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-23.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class OHAttributedLabel;

@interface WTOtherUserProfileView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *firstSectionBgImageView;
@property (nonatomic, weak) IBOutlet UIImageView *secondSectionBgImageView;
@property (nonatomic, weak) IBOutlet UIView *firstSectionContianerView;
@property (nonatomic, weak) IBOutlet UIView *secondSectionContianerView;
@property (nonatomic, weak) IBOutlet UILabel *detailInformationDisplayLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *scheduledActivityLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *scheduledCourseLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *friendLabel;
@property (nonatomic, weak) IBOutlet UILabel *birthdayLabel;
@property (nonatomic, weak) IBOutlet UILabel *studentNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *majorLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *emailLabel;
@property (nonatomic, weak) IBOutlet UILabel *weiboLabel;
@property (nonatomic, weak) IBOutlet UILabel *qqLabel;
@property (nonatomic, weak) IBOutlet UILabel *dormLabel;
@property (nonatomic, weak) IBOutlet UILabel *birthdayDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *studentNumberDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *majorDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *emailDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *weiboDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *qqDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *dormDisplayLabel;
@property (nonatomic, weak) IBOutlet UIButton *scheduledActivityButton;
@property (nonatomic, weak) IBOutlet UIButton *scheduledCourseButton;
@property (nonatomic, weak) IBOutlet UIButton *friendButton;
@property (nonatomic, weak) IBOutlet UIButton *phoneButton;
@property (nonatomic, weak) IBOutlet UIButton *emailButton;

+ (WTOtherUserProfileView *)createProfileViewWithUser:(User *)user;

@end
