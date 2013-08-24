//
//  WEMeDetailViewController.h
//  WeCampus
//
//  Created by Song on 13-8-24.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+Addition.h"

@interface WEMeDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *mottoLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *qqLabel;

- (void)configureWithUser:(User*)user;

@end
