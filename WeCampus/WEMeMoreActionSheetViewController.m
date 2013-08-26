//
//  WEMeMoreActionSheetViewController.m
//  WeCampus
//
//  Created by Song on 13-8-26.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEMeMoreActionSheetViewController.h"

@interface WEMeMoreActionSheetViewController ()

@end

@implementation WEMeMoreActionSheetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.maskView resetHeight:900];
    [self.maskView resetOriginYByOffset:-200];
    [self.containerView resetOriginY:self.view.frame.size.height];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:1.0f animations:^{
        [self.containerView resetOriginY:self.view.frame.size.height - self.containerView.frame.size.height];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickFinishSetting:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickFinshSetting)]) {
        [self.delegate didClickFinshSetting];
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (IBAction)clickDeleteFriend;
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickDeleteFriend)]) {
        [self.delegate didClickDeleteFriend];
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
@end
