//
//  WEMeDetailViewController.m
//  WeCampus
//
//  Created by Song on 13-8-24.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEMeDetailViewController.h"
#import "NSDate+WTAddition.h"
#import "UIImageView+AsyncLoading.h"
#import <QuartzCore/QuartzCore.h>

@interface WEMeDetailViewController ()

@end

@implementation WEMeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureWithUser:(User*)user
{
    self.mobileLabel.text = user.motto;
    self.birthdayLabel.text = [user.birthday convertToYearMonthDayString];
    self.numberLabel.text = user.studentNumber;
    self.schoolLabel.text = user.major;
    self.departmentLabel.text = user.department;
    self.mobileLabel.text = user.phoneNumber;
    self.emailLabel.text = user.emailAddress;
    self.qqLabel.text = user.qqAccount;
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.bounds.size.width / 2;
    [self.headImageView loadImageWithImageURLString:user.avatar];
}

@end
