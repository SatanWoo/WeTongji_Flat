//
//  WTSelectDormViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WTSelectDormViewControllerDelegate;

@interface WTSelectDormViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) id<WTSelectDormViewControllerDelegate> delegate;

+ (void)showWithDelegate:(id<WTSelectDormViewControllerDelegate>)delegate;

@end

@protocol WTSelectDormViewControllerDelegate <NSObject>

- (void)selectDormViewController:(WTSelectDormViewController *)vc
             didSelectDistribute:(NSString *)distribute
                        building:(NSString *)building
                      roomNumber:(NSString *)roomNumber;

@end
