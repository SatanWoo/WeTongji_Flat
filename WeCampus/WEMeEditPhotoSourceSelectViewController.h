//
//  WEMeMoreActionSheetViewController.h
//  WeCampus
//
//  Created by Song on 13-8-26.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WEMeEditPhotoSourceSelectViewControllerDelegate <NSObject>

- (void)didClickCancel;
- (void)didClickCamera;
- (void)didClickLibrary;

@end

@interface WEMeEditPhotoSourceSelectViewController : UIViewController
@property (weak, nonatomic) id<WEMeEditPhotoSourceSelectViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

- (IBAction)didClickCancel:(UIButton *)sender;
- (IBAction)didClickCamera:(UIButton *)sender;
- (IBAction)didClickLibrary:(UIButton *)sender;


@end
