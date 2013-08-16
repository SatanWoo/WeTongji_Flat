//
//  WENowPortraitDayEventListViewController.m
//  WeCampus
//
//  Created by Song on 13-8-13.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WENowPortraitDayEventListViewController.h"
#import "WTNowBaseCell.h"
#import "Activity+Addition.h"
#import "Course+Addition.h"
#import "Exam+Addition.h"
#import "Object+Addition.h"
#import "NSDate-Utilities.h"
#import "NSDate+WTAddition.h"

@interface WENowPortraitDayEventListViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation WENowPortraitDayEventListViewController

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
    needDate = [NSDate date];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadDataForDate:(NSDate*)date
{
    needDate = date;
    self.fetchedResultsController = nil;
    [NSFetchedResultsController deleteCacheWithName:nil];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [self configureFetchRequest:fetchRequest];
    [self.fetchedResultsController performFetch:NULL];
    [[super tableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableView Datasource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}



#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Event *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    WTNowBaseCell *nowCell = (WTNowBaseCell *)cell;
    [nowCell configureCellWithEvent:item];
    
    NSDate *nowDate = [NSDate date];
    if ([nowDate compare:item.beginTime] == NSOrderedAscending) {
        [nowCell updateCellStatus:WTNowBaseCellTypeNormal];
        
    } else if ([nowDate compare:item.endTime] == NSOrderedDescending) {
        [nowCell updateCellStatus:WTNowBaseCellTypePast];
    } else {
        [nowCell updateCellStatus:WTNowBaseCellTypeNow];
    }
}

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"(beginTime >= %@) AND (beginTime <= %@)", [needDate dateAtStartOfDay],[[needDate dateByAddingDays:1] dateAtStartOfDay]];
    
    //request.predicate = [NSPredicate predicateWithFormat:@"(beginTime <= %@)", [needDate dateAtStartOfDay]];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"beginTime" ascending:YES]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WTNowBaseCell";
}

- (NSString *)customSectionNameKeyPath {
    return @"beginDay";
}

- (void)fetchedResultsControllerDidPerformFetch {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 300 * NSEC_PER_MSEC), dispatch_get_current_queue(), ^{
//        if ([self.fetchedResultsController.sections.lastObject numberOfObjects] == 0) {
//            [self.dragToLoadDecorator setTopViewLoading:YES];
//        }
//    });
}

@end
