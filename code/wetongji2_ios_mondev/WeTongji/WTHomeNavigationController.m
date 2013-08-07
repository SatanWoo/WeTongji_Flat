//
//  WTHomeNavigationController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTHomeNavigationController.h"
#import "WTHomeViewController.h"

@interface WTHomeNavigationController ()

@end

@implementation WTHomeNavigationController

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
	// Do any additional setup after loading the view.
    WTHomeViewController *vc = [[WTHomeViewController alloc] init];
    [self pushViewController:vc animated:NO];
}

@end
