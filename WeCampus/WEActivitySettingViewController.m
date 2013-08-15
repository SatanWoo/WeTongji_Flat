//
//  WEActivitySettingViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-13.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEActivitySettingViewController.h"
#import "WTSwitch.h"

@interface WEActivitySettingViewController () <WTSwitchDelegate>
@property (nonatomic, strong) WTSwitch *swtich;
@end

@implementation WEActivitySettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.containerView resetOriginY:self.view.frame.size.height];
    [self configureAllCategoryButton];
    [self configureOrderMethodButton];
    [self configureSwitch];
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
}

- (IBAction)clickFinishSetting:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickFinshSetting)]) {
        [self.delegate didClickFinshSetting];
    }
}

#define switchX 236
#define switchY 242
#define hidePast @"ActivityHidePast"

- (void)configureSwitch
{
    self.swtich = [WTSwitch createSwitchWithDelegate:self];
    [self.swtich resetOriginX:switchX];
    [self.swtich resetOriginY:switchY];
    [self.containerView addSubview:self.swtich];
    
    self.swtich.on = [[NSUserDefaults standardUserDefaults] boolForKey:hidePast];
}

#define showCategory @"ActivityShowTypes"
#define orderMethod @"ActivityOrderMethod"

- (void)configureAllCategoryButton
{
    [self configureUserDefaultForCategory:showCategory button:self.wenyuButton];
    [self configureUserDefaultForCategory:showCategory button:self.jiangzuoButton];
    [self configureUserDefaultForCategory:showCategory button:self.zhaopingButton];
    [self configureUserDefaultForCategory:showCategory button:self.saishiButton];
}

- (void)configureOrderMethodButton
{
    [self configureUserDefaultForCategory:orderMethod button:self.newsButton];
    [self configureUserDefaultForCategory:orderMethod button:self.hotButton];
    [self configureUserDefaultForCategory:orderMethod button:self.latesetButton];
}

- (void)configureUserDefaultForCategory:(NSString *)type button:(UIButton *)btn
{
    NSLog(@"tag is %d",btn.tag);
    NSInteger value = 1 << btn.tag;
    NSLog(@"value is %d",value);
    NSInteger result = [[NSUserDefaults standardUserDefaults] integerForKey:type];
    NSLog(@"result is %d",result);
    if ([type isEqualToString:showCategory]) {
        btn.selected = ((result & value) != 0);
    } else {
        btn.selected = (value == result);
    }
}

- (IBAction)selectShowCategory:(UIButton *)sender
{
    sender.selected = !sender.selected;
    NSInteger itemValue = 1 << sender.tag;
    
    NSInteger result = [[NSUserDefaults standardUserDefaults] integerForKey:showCategory];
    if (!sender.selected)
        result &=  ~itemValue;
    else
        result |= itemValue;
    
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

#pragma mark - WTSwitchDelegate
- (void)switchDidChange:(WTSwitch *)sender
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:hidePast] != self.swtich.isOn) {
        
        [[NSUserDefaults standardUserDefaults] setBool:self.swtich.isOn forKey:hidePast];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
