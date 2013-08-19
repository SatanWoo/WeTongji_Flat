//
//  WEActivityDetailViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-15.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEActivityDetailViewController.h"
#import "WEActivityDetailHeaderView.h"
#import "WEActivityDetailContentView.h"
#import "WEDetailTransparentHeaderView.h"

@interface WEActivityDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) Activity *act;
@property (strong, nonatomic) WEActivityDetailContentView *contentViewCell;
@property (strong, nonatomic) WEActivityDetailHeaderView *detailHeaderView;
@property (strong, nonatomic) WEDetailTransparentHeaderView *transparentHeaderView;
@end

@implementation WEActivityDetailViewController

+ (WEActivityDetailViewController *)createDetailViewControllerWithModel:(Activity *)act
{
    WEActivityDetailViewController *vc = [[WEActivityDetailViewController alloc] initWithNibName:@"WEActivityDetailViewController" bundle:nil];
    vc.act = act;
    
    return vc;
}

- (WEActivityDetailContentView *)contentViewCell
{
    if (!_contentViewCell) {
        _contentViewCell = [WEActivityDetailContentView createDetailContentViewWithInfo:self.act];
    }
    return _contentViewCell;
}

- (WEActivityDetailHeaderView *)detailHeaderView
{
    if (!_detailHeaderView) {
        _detailHeaderView = [WEActivityDetailHeaderView createActivityDetailViewWithInfo:self.act];
    }
    return _detailHeaderView;
}

- (WEDetailTransparentHeaderView *)transparentHeaderView
{
    if (!_transparentHeaderView) {
        _transparentHeaderView = [WEDetailTransparentHeaderView createTransparentHeaderView];
    }
    return _transparentHeaderView;
}

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green_point"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 0;
    else return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) return 0;
    else return self.contentViewCell.frame.size.height;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return self.transparentHeaderView.frame.size.height;
    else return self.detailHeaderView.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.contentViewCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) return self.transparentHeaderView;
    return self.detailHeaderView;
}


#define kIgnoreOffset 34
#define autoScrollThershold 75
static CGFloat lastOffsetY = 0;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat height = self.transparentHeaderView.frame.size.height;
    
    [self.detailHeaderView resetLayout:(offsetY - kIgnoreOffset)/ height];
    [self.contentViewCell resetLayout:(offsetY - kIgnoreOffset)/ height];
    
    lastOffsetY = offsetY;
}

static bool hasEnterContentMode = false;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY > autoScrollThershold + kIgnoreOffset && !hasEnterContentMode) {
//        [self.tableView setContentOffset:CGPointMake(0, self.transparentHeaderView.frame.size.height)];
//        hasEnterContentMode = true;
//    } else if (offsetY <= autoScrollThershold +kIgnoreOffset && hasEnterContentMode) {
//        [self.tableView setContentOffset:CGPointMake(0, 0)];
//        hasEnterContentMode = false;
//    }
}

#pragma mark - IBAction
- (IBAction)popBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
