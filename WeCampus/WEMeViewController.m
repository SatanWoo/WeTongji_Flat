//
//  WEMeViewController.m
//  WeCampus
//
//  Created by Song on 13-8-20.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEMeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AsyncLoading.h"
#import "WTCoreDataManager.h"
#import "WTClient.h"
#import "WTRequest.h"
#import "WEMeDetailViewController.h"
#import "WEFriendListViewController.h"
#import "WEMeFriendListViewController.h"

@interface WEMeViewController ()<WEFriendListViewControllerDelegate>
{
    User *_user;
}
@end

@implementation WEMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initHeadImageView;
{
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.bounds.size.width / 2;
    self.headImageView.layer.borderWidth = 3.0;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentScrollVIew.alwaysBounceVertical = YES;
    [self initHeadImageView];
    
    UIViewController *root = self.navigationController.viewControllers[0];
    if(root == self)
    {
        self.backButto.hidden = YES;
    }
    // Do any additional setup after loading the view.
}



- (void)configureWithUser:(User*)user
{
    _user = user;
    [self.nameButton setTitle:user.name forState:UIControlStateNormal];
    self.genderImageView.image = [UIImage imageNamed:[user.gender isEqualToString:@"男"] ? @"person_male_icn.png" : @"person_female_icn.png"];
    self.descriptionLabel.text = user.motto;
    self.friendCountLabel.text = [NSString stringWithFormat:@"%@",user.friendCount];
    self.courseCountLabel.text = [NSString stringWithFormat:@"%@",user.scheduledCourseCount];
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d",user.likedObjects.count];
    
    [self.headImageView loadImageWithImageURLString:user.avatar];
	
    if([WTCoreDataManager sharedManager].currentUser == user)//self visit
    {
        self.addFriendButton.hidden = YES;
        self.likeButton.hidden = YES;
        self.genderImageView.hidden = YES;
    }
    else if([[WTCoreDataManager sharedManager].currentUser.friends member:user])//friend visit
    {
        self.addFriendButton.hidden = YES;
    }
}


#pragma mark - IBActions
- (IBAction)popBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)friendTapped:(id)sender
{
    WEMeFriendListViewController *vc = [[WEMeFriendListViewController alloc] init];
    vc.view;
    vc.friendOfPerson = _user;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)courseTapped:(id)sender
{
    
}

- (IBAction)likedTapped:(id)sender
{
    
}

- (IBAction)likeTheUserTapped:(id)sender
{
    
}

- (IBAction)addFriendTapped:(id)sender
{
    
}

- (IBAction)nameTapped:(id)sender
{
    WEMeDetailViewController *vc = [[WEMeDetailViewController alloc] init];
    [vc configureWithUser:_user];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)seeMoreTapped:(id)sender
{
    
}

#pragma mark WEFriendListViewControllerDelegate
- (void)WEFriendListViewController:(WEFriendListViewController*)vc didSelectUser:(User*)user
{
    WEMeViewController *mevc = [[WEMeViewController alloc] init];
    mevc.view;
    [mevc configureWithUser:user];
    [self.navigationController pushViewController:mevc animated:YES];
}

@end
