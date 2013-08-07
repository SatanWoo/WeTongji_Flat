//
//  WTCourseBaseHeaderView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEADER_VIEW_BOTTOM_INDENT   50.0f

@class Course;

@interface WTCourseBaseHeaderView : UIView

@property (nonatomic, strong) UIButton *friendCountButton;

@property (nonatomic, strong) UIButton *participateButton;

@property (nonatomic, strong) UIButton *inviteButton;

@property (nonatomic, assign) BOOL courseOutdated;

#pragma mark - Methods to overwrite

- (void)configureView;

- (Course *)targetCourse;

#pragma mark - Methods called by view controllers

- (void)configureInviteButton;

- (void)configureParticipateButtonStatus:(BOOL)participated;

@end
