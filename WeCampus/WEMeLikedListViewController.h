//
//  WEMeLikedListViewController.h
//  WeCampus
//
//  Created by Song on 13-8-28.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WTSearchResultTableViewController.h"

@interface WEMeLikedListViewController : UIViewController

@property (nonatomic, strong) NSArray *usersArray;
@property (nonatomic, strong) NSArray *orgsArray;
@property (nonatomic, strong) NSArray *actsArray;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;



- (UIViewController *)detailViewControllerForIndexPath:(NSIndexPath *)indexPath;

@end
