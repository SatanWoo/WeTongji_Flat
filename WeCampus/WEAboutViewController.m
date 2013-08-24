//
//  WEAboutViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-18.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEAboutViewController.h"

@interface WEAboutViewController ()

@end

@implementation WEAboutViewController

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
    self.title = @"关于";
    
    [self configureScrollView];
}

- (void)configureScrollView
{
    [self.scrollView resetHeight:self.view.frame.size.height];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 30);
    [self.scrollView setContentOffset:CGPointZero];
    
    [self.copyrightLabel resetOriginY:self.view.frame.size.height - 50];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
