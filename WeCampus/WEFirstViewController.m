//
//  WEFirstViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-10.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEFirstViewController.h"

@interface WEFirstViewController ()

@end

@implementation WEFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
