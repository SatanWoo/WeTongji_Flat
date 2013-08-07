//
//  WTNowNavigationController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowNavigationController.h"
#import "WTNowViewController.h"

@interface WTNowNavigationController ()

@end

@implementation WTNowNavigationController

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
    WTNowViewController *vc = [[WTNowViewController alloc] init];
    [self pushViewController:vc animated:NO];
}

- (BOOL)needUserLogin {
    return YES;
}

@end
