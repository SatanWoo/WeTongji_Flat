//
//  WTSearchDefaultViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-10.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTSearchHistoryView.h"

@protocol WTSearchDefaultViewControllerDelegate <NSObject>
- (void)didClickSearchHistoryItem:(NSString *)keyword;
@end

@interface WTSearchDefaultViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIView *shadowCoverView;
@property (nonatomic, weak, readonly) WTSearchHistoryView *historyView;
@property (weak, nonatomic) id<WTSearchDefaultViewControllerDelegate> delegate;

@end
