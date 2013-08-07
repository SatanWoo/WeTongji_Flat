//
//  WTSearchDefaultViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-10.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTSearchHistoryView.h"

@interface WTSearchDefaultViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIView *shadowCoverView;
@property (nonatomic, weak, readonly) WTSearchHistoryView *historyView;

@end
