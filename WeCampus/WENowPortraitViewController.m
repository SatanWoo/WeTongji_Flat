//
//  WENowPortraitViewController.m
//  WeCampus
//
//  Created by Song on 13-8-12.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WENowPortraitViewController.h"
#import "WTClient.h"
#import "WTRequest.h"
#import "User+Addition.h"
#import "WTCoreDataTableViewController.h"

@interface WENowPortraitViewController ()
{
    WENowPortraitWeekListViewController *weekTitleVC;
    WENowPortraitDayEventListViewController *dayEventListVC;
}
@end

@implementation WENowPortraitViewController

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
    
    WTClient *client = [WTClient sharedClient];
    WTRequest *request = [WTRequest requestWithSuccessBlock: ^(id responseData) {
        User *user = [User insertUser:[responseData objectForKey:@"User"]];
        [WTCoreDataManager sharedManager].currentUser = user;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
        
        request.predicate = [NSPredicate predicateWithFormat:@"(SELF in %@)", [WTCoreDataManager sharedManager].currentUser.scheduledEvents, [NSDate date]];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"beginTime" ascending:YES]];
        
        NSArray *matches = [[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:nil];
        NSLog(@"success :%@",matches);
        
    } failureBlock:^(NSError * error) {
        NSLog(@"fail");
    }];
    [request loginWithStudentNumber:@"000000" password:@"123456"];
    [client enqueueRequest:request];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    if(!weekTitleVC)
    {
        weekTitleVC = [[WENowPortraitWeekListViewController alloc] init];
        weekTitleVC.delegate = self;
        weekTitleVC.view.frame = self.weekTitleContainerView.bounds;
        [self.weekTitleContainerView addSubview:weekTitleVC.view];
    }
    if(!dayEventListVC)
    {
        dayEventListVC = [[WENowPortraitDayEventListViewController alloc] init];
        
        dayEventListVC.view.frame = self.dayEventListContainerView.bounds;
        [self.dayEventListContainerView addSubview:dayEventListVC.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Week List Delegate
- (void)weekListViewController:(WENowPortraitWeekListViewController*)vc dateDidChanged:(NSDate*)date
{
    NSLog(@"%@",date);
}

@end
