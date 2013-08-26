//
//  WEMeMoreActionSheetViewController.h
//  WeCampus
//
//  Created by Song on 13-8-26.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WEMeMoreActionSheetViewControllerDelegate <NSObject>

- (void)didClickFinshSetting;
- (void)didClickDeleteFriend;

@end

@interface WEMeMoreActionSheetViewController : UIViewController
@property (weak, nonatomic) id<WEMeMoreActionSheetViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)clickFinishSetting:(UIButton *)sender;
- (IBAction)clickDeleteFriend;

@end
