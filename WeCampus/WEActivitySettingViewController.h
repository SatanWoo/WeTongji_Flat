//
//  WEActivitySettingViewController.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-13.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WEActivitySettingViewControllerDelegate <NSObject>

- (void)didClickFinshSetting;

@end

@interface WEActivitySettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *wenyuButton;
@property (weak, nonatomic) IBOutlet UIButton *jiangzuoButton;
@property (weak, nonatomic) IBOutlet UIButton *newsButton;
@property (weak, nonatomic) IBOutlet UIButton *hotButton;
@property (weak, nonatomic) IBOutlet UIButton *latesetButton;
@property (weak, nonatomic) IBOutlet UIButton *saishiButton;
@property (weak, nonatomic) IBOutlet UIButton *zhaopingButton;
@property (weak, nonatomic) IBOutlet UISwitch *showExpireSwitch;
@property (weak, nonatomic) IBOutlet UIButton *finshButton;
@property (weak, nonatomic) id<WEActivitySettingViewControllerDelegate> delegate;

- (IBAction)selectShowCategory:(UIButton *)sender;
- (IBAction)selectOrderMethod:(UIButton *)sender;
- (IBAction)clickFinishSetting:(UIButton *)sender;

@end
