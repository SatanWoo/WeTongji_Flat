//
//  WTChangePasswordViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTChangePasswordViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *oldPasswordTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField *repeatPasswordTextField;
@property (nonatomic, weak) IBOutlet UIImageView *panelBgImageView;

@end
