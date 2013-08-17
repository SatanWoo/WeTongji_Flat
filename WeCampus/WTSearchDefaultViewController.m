//
//  WTSearchDefaultViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-10.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTSearchDefaultViewController.h"

@interface WTSearchDefaultViewController ()

@property (nonatomic, weak) WTSearchHistoryView *historyView;

@end

@implementation WTSearchDefaultViewController

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
    // Do any additional setup after loading the view from its nib.
    [self configureSearchHistoryView];
}

#pragma mark - UI methods

- (void)configureSearchHistoryView {
    WTSearchHistoryView *historyView = [WTSearchHistoryView createSearchHistoryView];
    [historyView resetHeight:self.view.frame.size.height];
    [self.view insertSubview:historyView belowSubview:self.shadowCoverView];
    self.historyView = historyView;
}

@end
