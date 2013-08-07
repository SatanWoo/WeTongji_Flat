//
//  WTNewsSettingViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-2-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNewsSettingViewController.h"
#import "WTConfigLoader.h"
#import "NSUserDefaults+WTAddition.h"
#import "WTResourceFactory.h"

@interface WTNewsSettingViewController ()

@end

@implementation WTNewsSettingViewController

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
    return [[WTConfigLoader sharedLoader] loadConfig:kWTNewsConfig];
}

- (BOOL)isSettingDifferentFromDefaultValue {
    return [[NSUserDefaults standardUserDefaults] isNewsSettingDifferentFromDefaultValue];
}

@end
