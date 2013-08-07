//
//  WTNewsBriefIntroductionView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-19.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class News;

@interface WTNewsBriefIntroductionView : UIView

@property (nonatomic, weak) IBOutlet UILabel *publisherLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *publishTimeLabel;

+ (WTNewsBriefIntroductionView *)createNewsBriefIntroductionViewWithNews:(News *)news;

@end

@interface WTOfficialNewsBriefIntroductionView : WTNewsBriefIntroductionView

+ (WTOfficialNewsBriefIntroductionView *)createOfficialNewsBriefIntroductionView;

@end

@interface WTRecommendationNewsBriefIntroductionView : WTNewsBriefIntroductionView

@property (nonatomic, weak) IBOutlet UIView *ticketInfoContainerView;
@property (nonatomic, weak) IBOutlet UILabel *ticketInfoLabel;
@property (nonatomic, weak) IBOutlet UIView *otherInfoContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *ticketIconImageView;
@property (nonatomic, weak) IBOutlet UIButton *locationButton;
@property (nonatomic, weak) IBOutlet UIImageView *posterImageView;

+ (WTRecommendationNewsBriefIntroductionView *)createRecommendationNewsBriefIntroductionView;

@end

@interface WTClubNewsBriefIntroductionView : WTNewsBriefIntroductionView

@property (nonatomic, weak) IBOutlet UIView *avatarContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;

+ (WTClubNewsBriefIntroductionView *)createClubNewsBriefIntroductionView;

@end
