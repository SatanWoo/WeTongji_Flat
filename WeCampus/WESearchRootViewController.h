//
//  WESearchRootViewController.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-17.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WERootViewController.h"

@interface WESearchRootViewController : WERootViewController
@property (weak, nonatomic) IBOutlet UIView *searchBarContainerView;
@property (weak, nonatomic) IBOutlet UITextField *searchBarTextField;
@property (weak, nonatomic) IBOutlet UIImageView *searchIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *resultContainerView;

@end
