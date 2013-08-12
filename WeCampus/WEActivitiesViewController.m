//
//  WEActivitiesViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-12.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEActivitiesViewController.h"
#import "UIBarButtonItem+Addition.h"

@interface WEActivitiesViewController ()
@property (assign, nonatomic) ActivityShowTypes type;
@end

@implementation WEActivitiesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithTitle:(ActivityShowTypes)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Method
- (void)configureNavigationBar
{
    if (self.type == ActivityShowTypesAll) {
        self.title = NSLocalizedString(@"Activities", nil);
    } else if (self.type == ActivityShowTypeAcademics) {
        self.title = NSLocalizedString(@"Academics", nil);
    } else if (self.type == ActivityShowTypeCompetition) {
        self.title = NSLocalizedString(@"Competition", nil);
    } else if (self.type == ActivityShowTypeEnterprise) {
        self.title = NSLocalizedString(@"Enterprise", nil);
    } else {
        self.title = NSLocalizedString(@"Entertainment", nil);
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    [self configureNavigationBarButton];
}

- (void)configureNavigationBarButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initBarButtonWithTarget:self action:nil normalImage:@"event_filter_btn"];
}

@end
