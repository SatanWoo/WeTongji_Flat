//
//  WTActivationViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OHAttributedLabel;

@interface WTActivationViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *infoPanelContainerView;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *agreementDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *activationGuideDisplayLabel;
@property (nonatomic, weak) IBOutlet UIImageView *panelBgImageView;
@property (nonatomic, weak) IBOutlet UITextField *accountTextField;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField *repeatPasswordTextField;

@end
