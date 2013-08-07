//
//  WTForgetPasswordViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTForgetPasswordViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *accountTextField;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UIImageView *panelBgImageView;
@property (nonatomic, weak) IBOutlet UILabel *resetPasswordGuideDisplayLabel;

@end
