//
//  WENowPortraitViewController.m
//  WeCampus
//
//  Created by Song on 13-8-12.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WENowPortraitViewController.h"
#import "WTClient.h"
#import "WTRequest.h"
#import "User+Addition.h"
#import "WTCoreDataTableViewController.h"
#import "Activity+Addition.h"
#import "Object+Addition.h"
#import "Course+Addition.h"
#import "Exam+Addition.h"
#import "NSDate-Utilities.h"
#import "NSDate+WTAddition.h"

@interface WENowPortraitViewController ()
{
    WENowPortraitWeekListViewController *weekTitleVC;
    WENowPortraitDayEventListViewController *dayEventListVC;
}
@end

@implementation WENowPortraitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadDataFrom:(NSDate *)fromDate
                  to:(NSDate *)toDate
        successBlock:(void (^)(void))success
        failureBlock:(void (^)(void))failure {
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        NSLog(@"Get Now Data Success: %@", responseData);
        
        if (success) {
            success();
        }
        
        NSDictionary *resultDict = (NSDictionary *)responseData;
        NSArray *activitiesArray = resultDict[@"Activities"];
        for (NSDictionary *dict in activitiesArray) {
            Activity *activity= [Activity insertActivity:dict];
            [activity setObjectHeldByHolder:[self class]];
        }
        
        NSArray *coursesArray = resultDict[@"CourseInstances"];
        for (NSDictionary *dict in coursesArray) {
            CourseInstance *courseInstance = [CourseInstance insertCourseInstance:dict];
            [courseInstance setObjectHeldByHolder:[self class]];
            courseInstance.scheduledByCurrentUser = YES;
        }
        
        NSArray *examsArray = resultDict[@"Exams"];
        for (NSDictionary *dict in examsArray) {
            Exam *exam = [Exam insertExam:dict];
            [exam setObjectHeldByHolder:[self class]];
            exam.scheduledByCurrentUser = YES;
        }
    } failureBlock:^(NSError * error) {
        
    }];
    [request getScheduleWithBeginDate:fromDate endDate:toDate];
    [[WTClient sharedClient] enqueueRequest:request];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WTClient *client = [WTClient sharedClient];
    WTRequest *request = [WTRequest requestWithSuccessBlock: ^(id responseData) {
        User *user = [User insertUser:[responseData objectForKey:@"User"]];
        [WTCoreDataManager sharedManager].currentUser = user;
        
        [self loadDataFrom:[[NSDate date] dateByAddingDays:-7] to:[[NSDate date] dateByAddingDays:0] successBlock:^()
        {
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
            
            request.predicate = [NSPredicate predicateWithFormat:@"(SELF in %@)", [WTCoreDataManager sharedManager].currentUser.scheduledEvents, [NSDate date]];
            request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"beginTime" ascending:YES]];
            
            NSArray *matches = [[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:nil];
            NSLog(@"success :%@",matches);
        }
        failureBlock:^()
        {
            NSLog(@"faill");
        }];
        
    } failureBlock:^(NSError * error) {
        NSLog(@"fail");
    }];
    [request loginWithStudentNumber:@"000000" password:@"123456"];
    [client enqueueRequest:request];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    if(!weekTitleVC)
    {
        weekTitleVC = [[WENowPortraitWeekListViewController alloc] init];
        weekTitleVC.delegate = self;
        weekTitleVC.view.frame = self.weekTitleContainerView.bounds;
        [self.weekTitleContainerView addSubview:weekTitleVC.view];
    }
    if(!dayEventListVC)
    {
        dayEventListVC = [[WENowPortraitDayEventListViewController alloc] init];
        
        dayEventListVC.view.frame = self.dayEventListContainerView.bounds;
        [self.dayEventListContainerView addSubview:dayEventListVC.view];
    }
    self.weekNumberLabel.text = [[NSDate date] convertToYearMonthDayString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBAction
- (IBAction)nowPressed:(id)sender
{
    [weekTitleVC selectToday];
    [dayEventListVC loadDataForDate:[NSDate date]];
    self.weekNumberLabel.text = [[NSDate date] convertToYearMonthDayString];
}


#pragma mark Week List Delegate
- (void)weekListViewController:(WENowPortraitWeekListViewController*)vc dateDidChanged:(NSDate*)date
{
    NSLog(@"%@",date);
    [dayEventListVC loadDataForDate:date];
    self.weekNumberLabel.text = [date convertToYearMonthDayString];
}

@end
