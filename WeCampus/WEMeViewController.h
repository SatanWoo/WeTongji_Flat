//
//  WEMeViewController.h
//  WeCampus
//
//  Created by Song on 13-8-20.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEActivityCell.h"
#import "User+Addition.h"
#import "WERootViewController.h"

@interface WEMeViewController : WERootViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionSheetButton;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;


@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollVIew;

@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIButton *friendButton;
@property (weak, nonatomic) IBOutlet UIButton *courseButton;
@property (weak, nonatomic) IBOutlet UIButton *favoritedButton;

@property (weak, nonatomic) IBOutlet UIButton *seeMoreButton;

@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;

@property (weak, nonatomic) IBOutlet WEActivityCell *firstEvent;
@property (weak, nonatomic) IBOutlet WEActivityCell *secondEvent;
@property (weak, nonatomic) IBOutlet UIButton *backButto;
@property (weak, nonatomic) IBOutlet UIView *headerView;


- (void)configureWithUser:(User*)user;

- (IBAction)popBack:(id)sender;


- (IBAction)friendTapped:(id)sender;
- (IBAction)courseTapped:(id)sender;
- (IBAction)likedTapped:(id)sender;
- (IBAction)likeTheUserTapped:(id)sender;
- (IBAction)addFriendTapped:(id)sender;
- (IBAction)nameTapped:(id)sender;
- (IBAction)seeMoreTapped:(id)sender;
- (IBAction)editProfileTapped:(id)sender;
- (IBAction)actionSheetTapped:(id)sender;
@end
