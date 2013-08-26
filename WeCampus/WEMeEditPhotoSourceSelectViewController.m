//
//  WEMeMoreActionSheetViewController.m
//  WeCampus
//
//  Created by Song on 13-8-26.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEMeEditPhotoSourceSelectViewController.h"

@interface WEMeEditPhotoSourceSelectViewController ()

@end

@implementation WEMeEditPhotoSourceSelectViewController

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

- (IBAction)didClickCancel:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCancel)]) {
        [self.delegate didClickCancel];
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (IBAction)didClickCamera:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCamera)]) {
        [self.delegate didClickCamera];
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (IBAction)didClickLibrary:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickLibrary)]) {
        [self.delegate didClickLibrary];
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
@end
