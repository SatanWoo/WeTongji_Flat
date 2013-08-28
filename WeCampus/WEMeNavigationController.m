//
//  WEMeNavigationController.m
//  WeCampus
//
//  Created by Song on 13-8-24.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEMeNavigationController.h"
#import "WEMeViewController.h"
#import "WTCoreDataManager.h"
#import "WTClient.h"
#import "WTRequest.h"

@interface WEMeNavigationController ()
{
    WEMeViewController *rootViewController;
}
@end

@implementation WEMeNavigationController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initRootViewController
{
    rootViewController = [[WEMeViewController alloc] init];
    //[self logIn];
//    if(![WTCoreDataManager sharedManager].currentUser)
//    {
//        [self logIn];
//    }
    [self pushViewController:rootViewController animated:NO];
}

@end
