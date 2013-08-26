//
//  WEMeViewController.m
//  WeCampus
//
//  Created by Song on 13-8-20.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEMeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AsyncLoading.h"
#import "WTCoreDataManager.h"
#import "WTClient.h"
#import "WTRequest.h"
#import "WEMeDetailViewController.h"
#import "WEFriendListViewController.h"
#import "WEMeFriendListViewController.h"
#import "NSString+WTAddition.h"
#import "WEMeMoreActionSheetViewController.h"
#import "WEMeEditViewController.h"

@interface WEMeViewController ()<WEFriendListViewControllerDelegate,WEMeMoreActionSheetViewControllerDelegate>
{
    User *_user;
}
@end

@implementation WEMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initHeadImageView;
{
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.bounds.size.width / 2;
    self.headImageView.layer.borderWidth = 3.0;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentScrollVIew.alwaysBounceVertical = YES;
    [self initHeadImageView];
    
    UIViewController *root = self.navigationController.viewControllers[0];
    if(root == self)
    {
        self.backButto.hidden = YES;
    }
    // Do any additional setup after loading the view.
}



- (void)configureWithUser:(User*)user
{
    _user = user;
    if([[WTCoreDataManager sharedManager].currentUser.likedObjects member:user])
    {
        [self.likeButton setSelected:YES];
    }
    [self.likeButton setTitle:[NSString stringWithFormat:@"%@",user.likeCount] forState:UIControlStateNormal];
    
    [self.nameButton setTitle:user.name forState:UIControlStateNormal];
    self.genderImageView.image = [UIImage imageNamed:[user.gender isEqualToString:@"男"] ? @"person_male_icn.png" : @"person_female_icn.png"];
    self.descriptionLabel.text = user.motto;
    self.friendCountLabel.text = [NSString stringWithFormat:@"%@",user.friendCount];
    self.courseCountLabel.text = [NSString stringWithFormat:@"%@",user.scheduledCourseCount];
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d",user.likedObjects.count];
    
    [self.headImageView loadImageWithImageURLString:user.avatar];
	
    if([WTCoreDataManager sharedManager].currentUser == user)//self visit
    {
        self.addFriendButton.hidden = YES;
        self.likeButton.hidden = YES;
        self.genderImageView.hidden = YES;
        self.actionSheetButton.hidden = YES;
    }
    else if([[WTCoreDataManager sharedManager].currentUser.friends member:user])//friend visit
    {
        self.addFriendButton.hidden = YES;
        self.actionSheetButton.hidden = NO;
    }
    else
    {
        self.actionSheetButton.hidden = YES;
    }
}


#pragma mark - IBActions

- (IBAction)editProfileTapped:(id)sender
{
    WEMeEditViewController *vc = [[WEMeEditViewController alloc] init];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)actionSheetTapped:(id)sender
{
    WEMeMoreActionSheetViewController *vc = [[WEMeMoreActionSheetViewController alloc] init];
    [self addChildViewController:vc];
    vc.delegate = self;
    [vc.view setFrame:self.view.bounds];
    [self.view addSubview:vc.view];
}

- (IBAction)popBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)friendTapped:(id)sender
{
    WEMeFriendListViewController *vc = [[WEMeFriendListViewController alloc] init];
    UIView *v = vc.view;
    NSLog(@"%@",v);
    vc.friendOfPerson = _user;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)courseTapped:(id)sender
{
    
}

- (IBAction)likedTapped:(id)sender
{
    
}

- (IBAction)likeTheUserTapped:(id)sender
{
    if([self.likeButton isSelected])
    {
        [self.likeButton setSelected:NO];
        [[WTCoreDataManager sharedManager].currentUser removeLikedObjectsObject:_user];
        int count = [_user.likeCount intValue];
        count--;
        _user.likeCount = @(count);
        [self.likeButton setTitle:[NSString stringWithFormat:@"%@",_user.likeCount] forState:UIControlStateNormal];
    }
    else
    {
        [self.likeButton setSelected:YES];
        [[WTCoreDataManager sharedManager].currentUser addLikedObjectsObject:_user];
        int count = [_user.likeCount intValue];
        count++;
        _user.likeCount = @(count);
        [self.likeButton setTitle:[NSString stringWithFormat:@"%@",_user.likeCount] forState:UIControlStateNormal];
    }
}

- (IBAction)addFriendTapped:(id)sender
{
    BOOL isFriend = [[WTCoreDataManager sharedManager].currentUser.friends containsObject:_user];
    if (!isFriend)
        [self changeFriendRelationship:NO];
    else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil) message:[NSString deleteFriendStringForFriendName:_user.name] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil)otherButtonTitles:NSLocalizedString(@"Yes", nil), nil] show];
    }
}

- (IBAction)nameTapped:(id)sender
{
    WEMeDetailViewController *vc = [[WEMeDetailViewController alloc] init];
    [vc configureWithUser:_user];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)seeMoreTapped:(id)sender
{
    
}

#pragma mark - Logic methods

- (void)changeFriendRelationship:(BOOL)isFriend {
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        [[[UIAlertView alloc] initWithTitle:@"注意" message:isFriend ? @"已删除好友" : @"已发送好友添加请求。" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
        [[WTCoreDataManager sharedManager].currentUser removeFriendsObject:_user];
        self.addFriendButton.hidden = NO;
    } failureBlock:^(NSError *error) {
        
    }];
    if (isFriend)
        [request removeFriend:_user.identifier];
    else
        [request inviteFriends:@[_user.identifier]];
    [[WTClient sharedClient] enqueueRequest:request];
}

#pragma mark WEFriendListViewControllerDelegate
- (void)WEFriendListViewController:(WEFriendListViewController*)vc didSelectUser:(User*)user
{
    WEMeViewController *mevc = [[WEMeViewController alloc] init];
    NSLog(@"%@",mevc.view);
    [mevc configureWithUser:user];
    [self.navigationController pushViewController:mevc animated:YES];
}

#pragma mark ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    {
        [self.headerView resetOriginY:-yOffset * 0.7];
    }
}

#pragma mark WEMeMoreActionSheetViewControllerDelegate
- (void)didClickFinshSetting
{
    
}

- (void)didClickDeleteFriend
{
    [self changeFriendRelationship:YES];
    self.actionSheetButton.hidden = YES;
    self.addFriendButton.hidden = NO;
}

@end
