//
//  WEModifyPasswordViewController.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-25.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEContentViewController.h"

@interface WEModifyPasswordViewController : WEContentViewController
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end
