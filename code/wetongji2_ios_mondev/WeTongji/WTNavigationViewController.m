//
//  WTNavigationViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-24.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNavigationViewController.h"

@interface WTNavigationViewController ()

@end

@implementation WTNavigationViewController

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
	// Do any additional setup after loading the view.
    [self configureNavigationBar];
}

- (void)configureNavigationBar {
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"WTNavigationBarBg"] forBarMetrics:UIBarMetricsDefault];
        if ([self.navigationBar respondsToSelector:@selector(shadowImage)])
            self.navigationBar.shadowImage = [[UIImage alloc] init];
    }
    
    UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTNavigationBarShadow"]];
    [shadowImageView resetOriginY:self.navigationBar.frame.size.height];
    [self.navigationBar insertSubview:shadowImageView atIndex:0];
    self.navigationBarShadowImageView = shadowImageView;
}

@end
