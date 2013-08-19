//
//  WEActivityDetailViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-15.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WECourseDetailViewController.h"
#import "WECourseDetailHeaderView.h"
#import "WECourseDetailContentView.h"
#import "WEDetailTransparentHeaderView.h"

@interface WECourseDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) Course *act;
@property (strong, nonatomic) WECourseDetailContentView *contentViewCell;
@property (strong, nonatomic) WECourseDetailHeaderView *detailHeaderView;
@property (strong, nonatomic) WEDetailTransparentHeaderView *transparentHeaderView;
@end

@implementation WECourseDetailViewController

+ (WECourseDetailViewController *)createDetailViewControllerWithModel:(Course *)act
{
    WECourseDetailViewController *vc = [[WECourseDetailViewController alloc] initWithNibName:@"WECourseDetailViewController" bundle:nil];
    vc.act = act;
    
    return vc;
}

- (WECourseDetailContentView *)contentViewCell
{
    if (!_contentViewCell) {
        _contentViewCell = [WECourseDetailContentView createDetailContentViewWithInfo:self.act];
    }
    return _contentViewCell;
}

- (WECourseDetailHeaderView *)detailHeaderView
{
    if (!_detailHeaderView) {
        _detailHeaderView = [WECourseDetailHeaderView createCourseDetailViewWithInfo:self.act];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
