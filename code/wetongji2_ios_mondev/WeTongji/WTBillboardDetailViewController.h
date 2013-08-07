//
//  WTBillboardDetailViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-24.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTDetailViewController.h"

@class BillboardPost;

@interface WTBillboardDetailViewController : WTDetailViewController

+ (WTBillboardDetailViewController *)createBillboardDetailViewControllerWithBillboardPost:(BillboardPost *)post
                                                                        backBarButtonText:(NSString *)backBarButtonText;
@end
