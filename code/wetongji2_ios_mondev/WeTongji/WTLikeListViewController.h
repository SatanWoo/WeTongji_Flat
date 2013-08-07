//
//  WTLikeListViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTShowAllKindsOfCellsViewController.h"

@interface WTLikeListViewController : WTShowAllKindsOfCellsViewController

+ (WTLikeListViewController *)createViewControllerWithUser:(User *)user
                                           likeObjectClass:(NSString *)likeObjectClass
                                            backButtonText:(NSString *)backButtonText;

@end
