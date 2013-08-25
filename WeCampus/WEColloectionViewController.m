//
//  WEColloectionViewController.m
//  WeCampus
//
//  Created by Song on 13-8-25.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEColloectionViewController.h"
#import "WEFriendHeadCell.h"
#import "WEFriendListHeaderView.h"
#import "NSString+NaturlLanguage.h"

@interface WEColloectionViewController ()
{
    NSArray *friendsArray;
    NSArray *friendsArrayIndex;
    
    NSDictionary *friendDict;
    
    Class c;
}

@end

@implementation WEColloectionViewController

- (void)setCellClass:(Class)cellClass
{
    c = cellClass;
}

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
    [self.collectionView registerClass:c forCellWithReuseIdentifier:@"WEFriendHeadCell"];
    [self.collectionView registerClass:[WEFriendListHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WEFriendListHeaderView"];
    
    self.collectionView.allowsMultipleSelection = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setData:(NSArray*)arr
{
    friendsArray = arr;
    [self sort];
    [self.collectionView reloadData];
}


- (NSArray*)selected
{
    NSMutableArray *arr = [@[] mutableCopy];
    NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
    for(NSIndexPath *indexPath in indexPaths)
    {
        WEFriendHeadCell *cell = (WEFriendHeadCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [arr addObject:cell.obj];
    }
    return arr;
}

- (void)sort
{
    NSMutableArray* arr = [@[] mutableCopy];
    for(int i = 0; i < friendsArray.count; i++)
    {
        id obj = friendsArray[i];
        NSString *name = [obj name];
        name = [NSString transformToLatin:name];
        name = [NSString removeAccent:name];
        name = [name uppercaseString];
        
        NSMutableDictionary *d = [NSMutableDictionary dictionary];
        d[@"NameLatin"] = name;
        d[@"Obj"] = obj;
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
    id obj = dict[@"Obj"];
    if([obj isKindOfClass:[User class]])
    {
        [cell configureWithUser:obj];
    }
    else if([obj isKindOfClass:[Organization class]])
    {
        [cell configureWithOrg:obj];
    }
    
    return cell;
}

- (void)unselectAll
{
    NSArray *selected = [self.collectionView indexPathsForSelectedItems];
    for(NSIndexPath *p in selected)
    {
        [self.collectionView deselectItemAtIndexPath:p animated:NO];
    }
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
    [self.delegate WEColloectionViewController:self didSelect:cell.obj];
}

@end
