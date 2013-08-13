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
    NSDate *today;
    
    NSMutableDictionary *buttonDateDict;
    
    NSArray *dateViewBlocks;
    
    int currentIndex;
    
    int maxIndex;
    int minIndex;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation WENowPortraitWeekListViewController

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
    [self grabWeekTitleLabels];
    [self grabSampleDateLables];
    buttonDateDict = [@{} mutableCopy];
    _selectedDate = today = [NSDate new];
    
    [self init3DateBlocks];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
    [self.scrollView setContentInset:UIEdgeInsetsMake(0, self.scrollView.bounds.size.width * 1, 0, self.scrollView.bounds.size.width * 1)];
    //[self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width, 0)];
    // Do any additional setup after loading the view from its nib.
}



#pragma mark Helper Methods

- (void)init3DateBlocks
{
    UIView *middleView = [self dateViewWithDay:_selectedDate];
    UIView *previous = [self dateViewWithDay:[_selectedDate dateBySubtractingDays:7]];
    UIView *next = [self dateViewWithDay:[_selectedDate dateByAddingDays:7]];
    [previous resetOriginX:-self.scrollView.bounds.size.width];
    [next resetOriginX:self.scrollView.bounds.size.width];
    dateViewBlocks = @[previous,middleView,next];
    for(UIView *view in dateViewBlocks)
    {
        [self.scrollView addSubview:view];
    }
    minIndex = -1;
    maxIndex = 1;
}


- (void)reloadView:(UIView *)view forDate:(NSDate*)date
{
    NSDate *startDay = [self lastSundayForDate:date];
    for(int i = 0; i < 7; i++)
    {
        NSDate *theDay = [startDay dateByAddingDays:i];
        UIButton *button = (UIButton*)[view viewWithTag:i + 1];
        [button setTitle:[NSString stringWithFormat:@"%d",theDay.day] forState:UIControlStateNormal];
        [self setDate:theDay ForButton:button];
    }
    [self updateButtonColors];
}

- (NSDate*)lastSundayForDate:(NSDate*)date
{
    if(date.weekday == 1)
        return date;
    return [date dateBySubtractingDays:date.weekday - 1];
}

- (void)setDate:(NSDate*)date ForButton:(UIButton*)button
{
    NSDate *previousDate = [self dateForButton:button];
    if(previousDate)
    {
        [buttonDateDict removeObjectForKey:previousDate];
    }
    buttonDateDict[date] = button;
}

- (NSDate*)startDateForView:(UIView*)view
{
    UIButton *button = (UIButton*)[view viewWithTag:1];
    return [self dateForButton:button];
}

- (NSDate*)dateForButton:(UIButton*)sender
{
    __block NSDate *date;
    [buttonDateDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        UIButton *button = obj;
        NSDate *theDay = key;
        if(button == sender)
        {
            date = theDay;
            *stop = YES;
        }
    }];
    return date;
}

- (void)updateButtonColors
{
    UIColor *selectColor = [UIColor colorWithRed:233/255.0 green:71/255.0 blue:59/255.0 alpha:1.0];
    
    [buttonDateDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        UIButton *button = obj;
        NSDate *theDay = key;
        if([_selectedDate isEqualToDateIgnoringTime:today])
        {
            [button setTitleColor:[theDay isToday] ? selectColor : [UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        else
        {
            if([theDay isToday])
            {
                [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }
            else if([theDay isEqualToDateIgnoringTime:_selectedDate])
            {
                [button setTitleColor:selectColor forState:UIControlStateNormal];
            }
            else
            {
                [button setTitleColor: [UIColor lightGrayColor] forState:UIControlStateNormal];
            }
        }
        
        [button setTitleColor:[button titleColorForState:UIControlStateNormal] forState:UIControlStateHighlighted];
    }];
}


#pragma mark Prepare Methods
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


#pragma mark 

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
        [button addTarget:self action:@selector(didTapOnDate:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:sampleDateLabel.font];
        [view addSubview:button];
        buttonDateDict[theDay] = button;
        button.tag = i + 1;
    }
    [self updateButtonColors];
    return view;
}


- (void)didTapOnDate:(UIButton*)sender
{
    NSDate *date = [self dateForButton:sender];
    if(!date)
    {
        NSLog(@"!!!!!!");
        return;
    }
    _selectedDate = date;
    [self.delegate weekListViewController:self dateDidChanged:_selectedDate];
    [self updateButtonColors];
}

#pragma mark 


- (void)selectDay:(NSDate*)date
{
    if([date isSameWeekAsDate:_selectedDate])
    {
        _selectedDate = date;
    }
    else
    {
        NSDate *toSelectSunday = [self lastSundayForDate:date];
        NSDate *currentSunday = [self lastSundayForDate:today];
        
        
        int expectIndex = [currentSunday distanceInDaysToDate:toSelectSunday] / 7;
        NSLog(@"expectIndex %d",expectIndex);
        [self.scrollView setContentOffset:CGPointMake(expectIndex * self.scrollView.bounds.size.width, 0) animated:YES];
        //currentIndex = expectIndex;
        _selectedDate = date;
    }
    
    [self updateButtonColors];
}

- (void)selectPreviousDay
{
    [self selectDay:[_selectedDate dateByAddingDays:-1]];
}

- (void)selectNextDay
{
    [self selectDay:[_selectedDate dateByAddingDays:1]];
}

#pragma mark UIScrollView Delegate
static int lastIndex;
static int originalIndex;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    lastIndex = currentIndex;
    originalIndex = currentIndex;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    CGFloat width = scrollView.frame.size.width;
    //NSLog(@"%f",scrollView.contentOffset.x);
    currentIndex = floorf((scrollView.contentOffset.x + width / 2) / width);

    NSDate *currentIndexStartDay = [self lastSundayForDate: [today dateByAddingDays:currentIndex * 7]];
    if(currentIndex != lastIndex)
    {
        NSLog(@"cur ind:%d",currentIndex);
        
        lastIndex = currentIndex;
        
        CGRect visibleRect = CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y, scrollView.frame.size.width, scrollView.frame.size.height);
        int invisibleIndex = -1;
        UIView *previousView;
        UIView *nextView;
        
        
        for(int i = 0; i < 3;i++)
        {
            UIView *v = dateViewBlocks[i];
            CGRect frame = v.frame;
            if(!CGRectIntersectsRect(visibleRect, frame))
            {
                invisibleIndex = i;
            }
            else if([[self startDateForView:v] isEarlierThanDate:currentIndexStartDay])
            {
                previousView = v;
            }
            else if([[self startDateForView:v] isLaterThanDate:currentIndexStartDay])
            {
                nextView = v;
            }
        }
        // NSLog(@"invisible:%d",invisibleIndex);
        
        if(!previousView)
        {
            NSLog(@"load previous view");
            [self reloadView:dateViewBlocks[invisibleIndex] forDate:[currentIndexStartDay dateByAddingDays:-7]];
            [dateViewBlocks[invisibleIndex] resetOriginX:(currentIndex - 1) * self.scrollView.bounds.size.width];
            while(currentIndex -1 < minIndex)
            {
                minIndex--;
                UIEdgeInsets insets = self.scrollView.contentInset;
                insets.left += self.scrollView.bounds.size.width;
                self.scrollView.contentInset = insets;
            }
        }
        if(!nextView)
        {
            NSLog(@"load next view");
            [self reloadView:dateViewBlocks[invisibleIndex] forDate:[currentIndexStartDay dateByAddingDays:+7]];
            [dateViewBlocks[invisibleIndex] resetOriginX:(currentIndex + 1) * self.scrollView.bounds.size.width];
            while(currentIndex + 1 > maxIndex)
            {
                maxIndex++;
                UIEdgeInsets insets = self.scrollView.contentInset;
                insets.right += self.scrollView.bounds.size.width;
                self.scrollView.contentInset = insets;
            }
        }
    }
}

- (void)scrollViewBecomeStable
{
    _selectedDate = [_selectedDate dateByAddingDays: (currentIndex - originalIndex) * 7];
    [self updateButtonColors];
    [self.delegate weekListViewController:self dateDidChanged:_selectedDate];
	NSLog(@"cur ind:%d",currentIndex);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating ");
    [self scrollViewBecomeStable];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging ");
    if (!decelerate) {
        [self scrollViewBecomeStable];
    }
}

@end
