//
//  WTShowAllKindsOfCellsViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCoreDataTableViewController.h"

@interface WTShowAllKindsOfCellsViewController : WTCoreDataTableViewController

@property (nonatomic, strong) NSArray *usersArray;
@property (nonatomic, strong) NSArray *orgsArray;
@property (nonatomic, strong) NSArray *actsArray;

- (UIViewController *)detailViewControllerForIndexPath:(NSIndexPath *)indexPath;

@end
