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

@interface WEMeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

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


- (void)configureWithUser:(User*)user;


- (IBAction)friendTapped:(id)sender;
- (IBAction)courseTapped:(id)sender;
- (IBAction)likedTapped:(id)sender;
- (IBAction)likeTheUserTapped:(id)sender;
- (IBAction)addFriendTapped:(id)sender;
- (IBAction)nameTapped:(id)sender;
- (IBAction)seeMoreTapped:(id)sender;
@end
