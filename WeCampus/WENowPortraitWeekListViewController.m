//
//  WENowPortraitWeekListViewController.m
//  WeCampus
//
//  Created by Song on 13-8-12.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WENowPortraitWeekListViewController.h"
#import "NSDate-Utilities.h"

@interface WENowPortraitWeekListViewController ()
{
    NSArray *weekTitleLabels;//from sunday to sat
    NSArray *sampleDateLables;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation WENowPortraitWeekListViewController

- (void)grabSampleDateLables
{
    NSMutableArray *arr = [@[] mutableCopy];
    for(int i = 11; i < 18; i++)
    {
        UILabel *label = (UILabel *)[self.view viewWithTag:i];
        if(i == 17)
           [arr insertObject:label atIndex:0];
        else
            [arr addObject:label];
        [label removeFromSuperview];
    }
    sampleDateLables = arr;
}

- (void)grabWeekTitleLabels
{
    NSMutableArray *arr = [@[] mutableCopy];
    for(int i = 1; i < 8; i++)
    {
        UILabel *label = (UILabel *)[self.view viewWithTag:i];
        if(i == 7)
            [arr insertObject:label atIndex:0];
        else
            [arr addObject:label];
    }
    weekTitleLabels = arr;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSDate*)lastSundayForDate:(NSDate*)date
{
    if(date.weekday == 1)
        return date;
    return [date dateBySubtractingDays:date.weekday - 1];
}

- (UIView*)dateViewWithDay:(NSDate*)day
{
    NSDate *startDay = [self lastSundayForDate:day];
    UIView *view = [[UIView alloc] initWithFrame:self.scrollView.bounds];
    for(int i = 0; i < 7; i++)
    {
        NSDate *theDay = [startDay dateByAddingDays:i];
        UILabel *sampleDateLabel = sampleDateLables[i];
        UIButton *button = [[UIButton alloc] initWithFrame:sampleDateLabel.frame];
        [button setTitle:[NSString stringWithFormat:@"%d",theDay.day] forState:UIControlStateNormal];
        [button setTitleColor:[theDay isToday] ? [UIColor darkGrayColor] : [UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[button titleColorForState:UIControlStateNormal] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:sampleDateLabel.font];
        [view addSubview:button];
    }
    return view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self grabWeekTitleLabels];
    [self grabSampleDateLables];
    
    [self.scrollView addSubview:[self dateViewWithDay:[NSDate new]]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
