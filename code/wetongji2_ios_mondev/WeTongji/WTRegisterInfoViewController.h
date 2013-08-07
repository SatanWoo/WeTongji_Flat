//
//  WTRegisterInfoViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OHAttributedLabel;

@interface WTRegisterInfoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UILabel *accountDisplayLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *agreementDisplayLabel;
@property (nonatomic, weak) IBOutlet UITextField *accountTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIView *avatarContainerView;

- (IBAction)didClickAvatarButton:(UIButton *)sender;

@end
