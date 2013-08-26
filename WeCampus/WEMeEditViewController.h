//
//  WEMeEditViewController.h
//  WeCampus
//
//  Created by Song on 13-8-26.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;
@interface WEMeEditViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UITextField *mottoTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *qqTextField;
@property (strong, nonatomic)  User *user;

- (void)configureWithUser:(User*)user;

- (IBAction)cancelPressed:(id)sender;
- (IBAction)savePressed:(id)sender;

- (IBAction)changeAvaterTapped:(id)sender;

@end
