//
//  WEMeFriendListViewController.h
//  WeCampus
//
//  Created by Song on 13-8-25.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEFriendListViewController.h"

@interface WEMeFriendListViewController : UIViewController

@property (retain,nonatomic) User *friendOfPerson;
@property (weak, nonatomic) IBOutlet UIView *containerVIew;
@property (nonatomic,assign) id<WEFriendListViewControllerDelegate> delegate;


- (IBAction)popBack:(id)sender;
@end
