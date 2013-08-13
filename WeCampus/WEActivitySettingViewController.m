//
//  WEActivitySettingViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-13.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEActivitySettingViewController.h"

@interface WEActivitySettingViewController ()

@end

@implementation WEActivitySettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#define offsetY 336

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.containerView resetOriginY:self.view.frame.size.height];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)clickFinishSetting:(UIButton *)sender
{
    [self.scrollView setContentOffset:CGPointMake(0, -offsetY) animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickFinshSetting)]) {
        [self.delegate didClickFinshSetting];
    }
}

#define showCategory @"ActivityShowTypes"
#define orderMethod @"ActivityOrderMethod"

- (IBAction)selectShowCategory:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    NSInteger result = [[NSUserDefaults standardUserDefaults] integerForKey:showCategory];
    if (!sender.selected)
        result &=  ~sender.tag;
    else
        result |= sender.tag;
    [[NSUserDefaults standardUserDefaults] setInteger:result forKey:showCategory];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)selectOrderMethod:(UIButton *)sender
{
    [self resetAllOrderMethodButton];
    sender.selected = YES;
    
    NSInteger itemValue = 1 << sender.tag;
    [[NSUserDefaults standardUserDefaults] setInteger:itemValue forKey:orderMethod];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)resetAllOrderMethodButton
{
    self.newsButton.selected = NO;
    self.hotButton.selected = NO;
    self.latesetButton.selected = NO;
}

@end
