//
//  WTSearchViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 12-11-13.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTRootViewController.h"

@interface WTSearchViewController : WTRootViewController <UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

- (void)showSearchResultWithSearchKeyword:(NSString *)keyword
                           searchCategory:(NSInteger)category;

@end
