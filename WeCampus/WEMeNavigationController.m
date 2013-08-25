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
    if(![WTCoreDataManager sharedManager].currentUser)
    {
        [self logIn];
    }
    [self pushViewController:rootViewController animated:NO];
}

- (void)logIn
{
    WTClient *client = [WTClient sharedClient];
    WTRequest *request = [WTRequest requestWithSuccessBlock: ^(id responseData)
                          {
                              User *user = [User insertUser:[responseData objectForKey:@"User"]];
                              [WTCoreDataManager sharedManager].currentUser = user;
                              [rootViewController configureWithUser:user];
                              
                          } failureBlock:^(NSError * error) {
                              NSLog(@"fail");
                          }];
    [request loginWithStudentNumber:@"000000" password:@"123456"];
    [client enqueueRequest:request];
}
@end
