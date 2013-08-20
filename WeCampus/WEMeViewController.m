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
    [self.headImageView loadImageWithImageURLString:@"http://lorempixel.com/90/90/people"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
