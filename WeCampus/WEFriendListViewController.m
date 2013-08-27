//
//  WEFriendListViewController.m
//  WeCampus
//
//  Created by Song on 13-8-17.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEFriendListViewController.h"
#import "WEFriendHeadCell.h"
#import "WTClient.h"
#import "WTCoreDataManager.h"
#import "WTRequest.h"
#import "NSString+NaturlLanguage.h"
#import "WEFriendListHeaderView.h"
#import "WEColloectionViewController.h"

@interface WEFriendListViewController ()<WEColloectionViewControllerDelegate>
{
    WEColloectionViewController *collectionVC;
    
    NSMutableArray *users;
}
@end

@implementation WEFriendListViewController

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
}

- (void)viewDidAppear:(BOOL)animated
{
    if(!self.friendOfPerson)
    {
        self.friendOfPerson = [WTCoreDataManager sharedManager].currentUser;
    }
    [self loadMoreDataWithSuccessBlock:nil failureBlock:nil];
    
    collectionVC = [[WEColloectionViewController alloc] init];
    [collectionVC setCellClass:[WEFriendHeadCell class]];
    collectionVC.delegate = self;
    collectionVC.view.frame = self.view.bounds;
    [self.view addSubview:collectionVC.view];
}

- (void)unselectAll
{
    [collectionVC unselectAll];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data load methods

- (void)loadMoreDataWithSuccessBlock:(void (^)(void))success
                        failureBlock:(void (^)(void))failure {
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        NSLog(@"Get friend list: %@", responseData);
        
        NSDictionary *resultDict = (NSDictionary *)responseData;
        NSMutableArray *arr= [@[] mutableCopy];
        arr = [resultDict[@"Users"] mutableCopy];
        users  = [@[] mutableCopy];
        for(NSDictionary *dict in arr)
        {
            [users addObject:[User insertUser:dict]];
        }
        [collectionVC setData:users];
        
        if (success)
            success();
        
    } failureBlock:^(NSError * error) {
        NSLog(@"Get friend list:%@", error.localizedDescription);
        
        if (failure)
            failure();
        
    }];
    if ([WTCoreDataManager sharedManager].currentUser == self.friendOfPerson)
        [request getFriendsList];
    else
        [request getFriendsOfUser:self.friendOfPerson.identifier];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (NSArray*)selectedUsers
{
    return [collectionVC selected];
}


#pragma mark WEColloectionViewControllerDelegate
- (void)WEColloectionViewController:(WEColloectionViewController*)vc didSelect:(id)obj
{
    [self.delegate WEFriendListViewController:self didSelectUser:obj];
}


@end
