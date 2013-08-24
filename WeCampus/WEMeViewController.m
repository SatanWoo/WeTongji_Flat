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

@interface WEMeViewController ()

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
    // Do any additional setup after loading the view.
}

- (void)configureWithUser:(User*)user
{
    [self.nameButton setTitle:user.name forState:UIControlStateNormal];
    //self.genderImageView.image = [UIImage imageNamed:user.gender ];
    
    self.friendCountLabel.text = [NSString stringWithFormat:@"%@",user.friendCount];
    self.courseCountLabel.text = [NSString stringWithFormat:@"%@",user.scheduledCourseCount];
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d",user.likedObjects.count];
    
    [self.headImageView loadImageWithImageURLString:user.avatar];
	
}


#pragma mark - IBActions
- (IBAction)friendTapped:(id)sender
{
    
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
    
}

- (IBAction)seeMoreTapped:(id)sender
{
    
}

@end
