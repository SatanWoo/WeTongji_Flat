//
//  WTOrganizationActivityViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-6-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTOrganizationActivityViewController.h"
#import "NSUserDefaults+WTAddition.h"
#import "Organization+Addition.h"
#import "WTResourceFactory.h"
#import "Controller+Addition.h"
#import "Activity+Addition.h"
#import "Object+Addition.h"

@interface WTOrganizationActivityViewController ()

@property (nonatomic, strong) Organization *org;

@end

@implementation WTOrganizationActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"WTActivityViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createBackBarButtonWithText:self.org.name target:self action:@selector(didClickBackButton:)];
    
    self.navigationItem.rightBarButtonItem = nil;
}

+ (WTOrganizationActivityViewController *)createViewControllerWithOrganization:(Organization *)org {
    WTOrganizationActivityViewController *result = [[WTOrganizationActivityViewController alloc] init];
    
    result.org = org;
    
    return result;
}

#pragma mark - Methods to overwrite

- (void)configureLoadedActivity:(Activity *)activity {
    [activity setObjectHeldByHolder:[self class]];
}

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"Activity" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    NSSortDescriptor *updateTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updatedAt" ascending:YES];
    NSSortDescriptor *beginTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"beginTime" ascending:NO];
    [request setSortDescriptors:@[beginTimeDescriptor, updateTimeDescriptor]];
     
     [request setPredicate:[NSPredicate predicateWithFormat:@"(SELF in %@) AND (SELF in %@)", [Controller controllerModelForClass:[self class]].hasObjects, self.org.publishedActivities]];
     }
     
     - (void)clearOutdatedData {
         NSSet *activityShowTypesSet = [NSUserDefaults getActivityShowTypesSet];
         for (NSNumber *showTypeNumber in activityShowTypesSet) {
             [Activity setOutdatedActivitesFreeFromHolder:[self class] inCategory:showTypeNumber];
         }
     }
     
     - (void)configureLoadDataRequest:(WTRequest *)request {
         [request getActivitiesInTypes:[NSUserDefaults getShowAllActivityTypesArray]
                           orderMethod:ActivityOrderByStartDate
                            smartOrder:YES
                            showExpire:YES
                                  page:self.nextPage
                             byAccount:self.org.identifier];
     }
     
     @end
