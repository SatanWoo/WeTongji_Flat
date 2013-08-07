//
//  WTSearchResultTableViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTShowAllKindsOfCellsViewController.h"

@protocol WTSearchResultTableViewControllerDelegate <NSObject>

- (void)wantToPushViewController:(UIViewController *)viewController;

@end

@interface WTSearchResultTableViewController : WTShowAllKindsOfCellsViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, copy, readonly) NSString *searchKeyword;

@property (nonatomic, weak) id<WTSearchResultTableViewControllerDelegate> delegate;

+ (WTSearchResultTableViewController *)createViewControllerWithSearchKeyword:(NSString *)keyword
                                                              searchCategory:(NSInteger)category
                                                                    delegate:(id<WTSearchResultTableViewControllerDelegate>)delegate;

@end
