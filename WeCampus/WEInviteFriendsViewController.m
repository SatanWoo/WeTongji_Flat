//
//  WEInviteFriendsViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-27.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEInviteFriendsViewController.h"
#import "WEColloectionViewController.h"
#import "WEFriendHeadCell.h"

#import "WTClient.h"
#import "WTRequest.h"
#import "User+Addition.h"

@interface WEInviteFriendsViewController ()<WEColloectionViewControllerDelegate>
@property (strong, nonatomic) WEColloectionViewController *collectionViewController;
@end

@implementation WEInviteFriendsViewController
+ (WEInviteFriendsViewController *)createInviteFriendsViewControllerWithDelegate:(id<WEInviteFriendsViewControllerDelegate>)target
{
    WEInviteFriendsViewController *controller = [[WEInviteFriendsViewController alloc] init];
    controller.delegate = target;
    
    return controller;
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
    [self configureCollectionView];
    
    [self.maskView resetHeight:460];
    [self.maskView resetOriginY:0];
    [self.containerView resetOriginY:self.view.frame.size.height];
    [self.controlArea resetOriginY:self.view.frame.size.height + self.controlArea.frame.size.height];
    
    [self loadMoreDataWithSuccessBlock:^(NSArray *datas) {
        [self.collectionViewController setData:datas];
    } failureBlock:^{
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.5f animations:^{
        [self.containerView resetOriginY:self.view.frame.size.height - self.containerView.frame.size.height - self.controlArea.frame.size.height];
        [self.controlArea resetOriginY:self.view.frame.size.height - self.controlArea.frame.size.height];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Load Data

- (void)loadMoreDataWithSuccessBlock:(void (^)(NSArray *datas))success
                        failureBlock:(void (^)(void))failure {
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        
        NSDictionary *resultDict = (NSDictionary *)responseData;
        NSMutableArray *arr= [@[] mutableCopy];
        arr = [resultDict[@"Users"] mutableCopy];
        
        NSMutableArray* users  = [@[] mutableCopy];
        for(NSDictionary *dict in arr)
        {
            [users addObject:[User insertUser:dict]];
        }
        
        if (success)
            success(users);
        
    } failureBlock:^(NSError * error) {
        if (failure)
            failure();
        
    }];
    [request getFriendsList];
    [[WTClient sharedClient] enqueueRequest:request];
}

#pragma mark - UI Method
- (void)configureCollectionView
{
    [self.collectionViewController setCellClass:[WEFriendHeadCell class]];
    self.collectionViewController.delegate = self;
    self.collectionViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:self.collectionViewController.view];
}

#pragma mark - Properties
- (WEColloectionViewController *)collectionViewController
{
    if (!_collectionViewController) {
        _collectionViewController = [[WEColloectionViewController alloc] init];
        _collectionViewController.delegate = self;
    }
    return _collectionViewController;
}

#pragma mark - IBAction
- (IBAction)didClickCancel:(id)sender
{
    if (self.delegate)
        [self.delegate cancelInviteFriends];
}

- (IBAction)didClickFinishInvitingFriends:(id)sender
{
    if (self.delegate)
        [self.delegate finishInviteFriends:self.collectionViewController.selected];
}

#pragma mark - WEColloectionViewControllerDelegate
- (void)WEColloectionViewController:(WEColloectionViewController*)vc didSelect:(id)obj
{
    
}

@end
