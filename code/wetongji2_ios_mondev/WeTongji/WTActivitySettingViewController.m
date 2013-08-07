//
//  WTActivitySettingViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-2-10.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTActivitySettingViewController.h"
#import "WTConfigLoader.h"
#import "WTResourceFactory.h"
#import "NSUserDefaults+WTAddition.h"

@interface WTActivitySettingViewController ()

@end

@implementation WTActivitySettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"WTInnerSettingViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (NSArray *)loadSettingConfig {
    return [[WTConfigLoader sharedLoader] loadConfig:kWTActivityConfig];
}

- (BOOL)isSettingDifferentFromDefaultValue {
    return [[NSUserDefaults standardUserDefaults] isActivitySettingDifferentFromDefaultValue];
}

@end
