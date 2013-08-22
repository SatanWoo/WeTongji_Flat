//
//  WEActivityDetailViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-15.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.


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
    self.tableView.scrollsToTop = YES;
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
static CGFloat lastOffsetY = 0;
static bool shouldRecalculateTransparecy = false;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    lastOffsetY = scrollView.contentOffset.y;
    shouldRecalculateTransparecy = true;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 80 && lastOffsetY < offsetY) {
        shouldRecalculateTransparecy = false;
        
        [UIView animateWithDuration:1.5f animations:^{
            self.tableView.contentOffset = CGPointMake(0, self.transparentHeaderView.frame.size.height + 150);
            [self resetTransparentLayout];
        } completion:^(BOOL finished) {
            
            
        }];
    } else if (offsetY < 250 && lastOffsetY > offsetY) {
        shouldRecalculateTransparecy = false;
        
        [UIView animateWithDuration:1.5f animations:^{
            self.tableView.contentOffset = CGPointZero;
             [self resetNormalLayout];
        } completion:^(BOOL finished) {
            [self.tableView setContentOffset:CGPointZero animated:NO];
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!shouldRecalculateTransparecy) return;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat height = self.transparentHeaderView.frame.size.height;
    
    [self resetTableViewLayout:(offsetY - kIgnoreOffset)/ height];
}

- (void)resetTableViewLayout:(CGFloat)percent
{
    [self.detailHeaderView resetLayout:percent];
    [self.contentViewCell resetLayout:percent];
}

- (void)resetNormalLayout
{
    [self.detailHeaderView resetNormalLayout];
    [self.contentViewCell resetNormalLayout];
}

- (void)resetTransparentLayout
{
    [self.detailHeaderView resetTransparentLayout];
    [self.contentViewCell resetTransparentLayout];
}

#pragma mark - IBAction
- (IBAction)popBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
