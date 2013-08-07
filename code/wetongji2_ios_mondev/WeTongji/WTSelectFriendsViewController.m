//
//  WTSelectFriendsViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-6-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTSelectFriendsViewController.h"
#import "WTNavigationViewController.h"
#import "UIApplication+WTAddition.h"
#import "WTResourceFactory.h"
#import "NSString+WTAddition.h"
#import "WTCoreDataManager.h"
#import "WTSelectUserCell.h"

@interface WTSelectFriendsViewController ()

@property (nonatomic, strong) NSMutableArray *selectedFriendsArray;
@property (nonatomic, weak) UIButton *finishSelectButton;

@end

@implementation WTSelectFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.selectedFriendsArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureNavigationBar];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

+ (WTSelectFriendsViewController *)showWithDelegate:(id<WTSelectFriendsViewControllerDelegate>)delegate {
    WTSelectFriendsViewController *vc = [[WTSelectFriendsViewController alloc] init];
    
    vc.delegate = delegate;
    
    WTNavigationViewController *nav = [[WTNavigationViewController alloc] initWithRootViewController:vc];
    
    UIViewController *rootVC = [UIApplication sharedApplication].rootTabBarController;
    [rootVC presentViewController:nav animated:YES completion:nil];
    
    return vc;
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    UIBarButtonItem *cancalBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Cancel", nil) target:self action:@selector(didClickCancelButton:)];
    self.navigationItem.leftBarButtonItem = cancalBarButtonItem;
    
    UIButton *finishSelectButton = [WTResourceFactory createFocusButtonWithText:NSLocalizedString(@"Invite", nil)];
    finishSelectButton.alpha = 0.5f;
    finishSelectButton.userInteractionEnabled = NO;
    [finishSelectButton addTarget:self action:@selector(didClickFinishSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    self.finishSelectButton = finishSelectButton;
    
    UIBarButtonItem *introBarButtonItem = [WTResourceFactory createBarButtonWithButton:finishSelectButton];
    self.navigationItem.rightBarButtonItem = introBarButtonItem;
    
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Invite Friends", nil)];
}

- (void)updateFinishSelectButton {
    if (self.selectedFriendsArray.count > 0) {
        self.finishSelectButton.alpha = 1.0f;
        self.finishSelectButton.userInteractionEnabled = YES;
        [self.finishSelectButton setTitle:[NSString inviteStringConvertFromCount:self.selectedFriendsArray.count] forState:UIControlStateNormal];
    } else {
        self.finishSelectButton.alpha = 0.5f;
        self.finishSelectButton.userInteractionEnabled = NO;
        [self.finishSelectButton setTitle:NSLocalizedString(@"Invite", nil) forState:UIControlStateNormal];
    }
}

#pragma mark - Actions

- (void)didClickFinishSelectButton:(UIButton *)sender {
    UIViewController *rootVC = [UIApplication sharedApplication].rootTabBarController;
    [rootVC dismissViewControllerAnimated:YES completion:^{
        [self.delegate selectFriendViewController:self didSelectFriends:self.selectedFriendsArray];
    }];
}

- (void)didClickCancelButton:(UIButton *)sender {
    UIViewController *rootVC = [UIApplication sharedApplication].rootTabBarController;
    [rootVC dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(selectFriendViewControllerDidCancel:)])
            [self.delegate selectFriendViewControllerDidCancel:self];
    }];
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WTSelectUserCell *userCell = (WTSelectUserCell *)cell;
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [userCell configureCellWithIndexPath:indexPath user:user];
    
    userCell.checkmarkButton.selected = [self.selectedFriendsArray containsObject:user];
}

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [request setSortDescriptors:@[nameDescriptor]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"(SELF in %@)", [WTCoreDataManager sharedManager].currentUser.friends]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WTSelectUserCell";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.selectedFriendsArray addObject:user];
    WTSelectUserCell *userCell = (WTSelectUserCell *)[tableView cellForRowAtIndexPath:indexPath];
    userCell.checkmarkButton.selected = YES;
    
    [self updateFinishSelectButton];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.selectedFriendsArray removeObject:user];
    WTSelectUserCell *userCell = (WTSelectUserCell *)[tableView cellForRowAtIndexPath:indexPath];
    userCell.checkmarkButton.selected = NO;
    
    [self updateFinishSelectButton];
}

@end
