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

@interface WEFriendListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSArray *friendsArray;
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
    [self.collectionView registerClass:[WEFriendHeadCell class] forCellWithReuseIdentifier:@"WEFriendHeadCell"];
    
    [self logIn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data load methods

- (void)logIn
{
    WTClient *client = [WTClient sharedClient];
    WTRequest *request = [WTRequest requestWithSuccessBlock: ^(id responseData)
    {
        User *user = [User insertUser:[responseData objectForKey:@"User"]];
        [WTCoreDataManager sharedManager].currentUser = user;
        [self loadMoreDataWithSuccessBlock:nil failureBlock:nil];
        
    } failureBlock:^(NSError * error) {
        NSLog(@"fail");
    }];
    [request loginWithStudentNumber:@"000000" password:@"123456"];
    [client enqueueRequest:request];
}

- (void)loadMoreDataWithSuccessBlock:(void (^)(void))success
                        failureBlock:(void (^)(void))failure {
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        NSLog(@"Get friend list: %@", responseData);
        
        if (success)
            success();
        
        NSDictionary *resultDict = (NSDictionary *)responseData;
        friendsArray = resultDict[@"Users"];
        [self.collectionView reloadData];
        
    } failureBlock:^(NSError * error) {
        NSLog(@"Get friend list:%@", error.localizedDescription);
        
        if (failure)
            failure();
        
    }];
    //if ([WTCoreDataManager sharedManager].currentUser == self.user)
    [request getFriendsList];
    //else
    //    [request getFriendsOfUser:self.user.identifier];
    [[WTClient sharedClient] enqueueRequest:request];
}

#pragma mark UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return friendsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WEFriendHeadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WEFriendHeadCell" forIndexPath:indexPath];
    
    NSDictionary *dict = friendsArray[indexPath.row];
    User *user = [User insertUser:dict];
    [cell configureWithUser:user];
    
    return cell;
}


@end
//