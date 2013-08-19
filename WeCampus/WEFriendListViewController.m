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

@interface WEFriendListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSArray *friendsArray;
    NSArray *friendsArrayIndex;
    
    NSDictionary *friendDict;
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
    [self.collectionView registerClass:[WEFriendListHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WEFriendListHeaderView"];
    
    [self logIn];
    
    self.collectionView.allowsMultipleSelection = YES;
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
        if(!self.friendOfPerson)
        {
            self.friendOfPerson = user;
        }
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
        [self sort];
        [self.collectionView reloadData];
        
    } failureBlock:^(NSError * error) {
        NSLog(@"Get friend list:%@", error.localizedDescription);
        
        if (failure)
            failure();
        
    }];
    //if ([WTCoreDataManager sharedManager].currentUser == self.user)
    //[request getFriendsList];
    //else
    [request getFriendsOfUser:self.friendOfPerson.identifier];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)sort
{
    NSMutableArray* arr = [@[] mutableCopy];
    for(int i = 0; i < friendsArray.count; i++)
    {
        NSDictionary *dict = friendsArray[i];
        NSString *name = dict[@"Name"];
        name = [NSString transformToLatin:name];
        name = [NSString removeAccent:name];
        name = [name uppercaseString];
        
        NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:dict];
        d[@"NameLatin"] = name;
        [arr addObject:d];
    }
    
    
    [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDictionary *dict1 = obj1;
        NSString *name1 = dict1[@"NameLatin"];
        
        NSDictionary *dict2 = obj2;
        NSString *name2 = dict2[@"NameLatin"];

        return  [name1 compare:name2];
    }];
    
    
    NSMutableArray *result = [@[] mutableCopy];
    NSMutableDictionary *firstLetters = [@{} mutableCopy];
    for(NSDictionary* dict in arr)
    {
        NSString *firstLetter = [dict[@"NameLatin"] substringToIndex:1];
        
        NSMutableArray *letterArr = firstLetters[firstLetter];
        if(!letterArr)
        {
            letterArr = [@[] mutableCopy];
            [result addObject:firstLetter];
        }
        [letterArr addObject:dict];
        firstLetters[firstLetter] = letterArr;
        
    }
    friendsArrayIndex = result;
    friendDict = firstLetters;
}

- (NSArray*)selectedUsers
{
    NSMutableArray *arr = [@[] mutableCopy];
    NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
    for(NSIndexPath *indexPath in indexPaths)
    {
        WEFriendHeadCell *cell = (WEFriendHeadCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [arr addObject:cell.user];
    }
    return arr;
}

#pragma mark UICollectionView Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return friendsArrayIndex.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arr = friendDict[friendsArrayIndex[section]];
    return arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WEFriendHeadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WEFriendHeadCell" forIndexPath:indexPath];
    
    NSDictionary *dict = friendDict[friendsArrayIndex[indexPath.section]][indexPath.row];
    User *user = [User insertUser:dict];
    [cell configureWithUser:user];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        WEFriendListHeaderView *v = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WEFriendListHeaderView" forIndexPath:indexPath];
        [v configureWithString:friendsArrayIndex[indexPath.section]];
        return v;
    }
    return nil;
}

#pragma mark UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WEFriendHeadCell *cell = (WEFriendHeadCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.delegate WEFriendListViewController:self didSelectUser:cell.user];
}

@end
//