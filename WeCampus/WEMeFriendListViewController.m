//
//  WEMeFriendListViewController.m
//  WeCampus
//
//  Created by Song on 13-8-25.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEMeFriendListViewController.h"

@interface WEMeFriendListViewController ()
{
    WEFriendListViewController *friendListVC;
}
@end

@implementation WEMeFriendListViewController

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
    friendListVC = [[WEFriendListViewController alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)setDelegate:(id<WEFriendListViewControllerDelegate>)delegate
{
    friendListVC.delegate = delegate;
}

- (void)viewDidAppear:(BOOL)animated
{
    friendListVC.friendOfPerson = self.friendOfPerson;
    [self.containerVIew addSubview:friendListVC.view];
    
    [friendListVC unselectAll];
    
    friendListVC.view.frame = self.containerVIew.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
