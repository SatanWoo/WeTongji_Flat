//
//  WTOrganizationNewsViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-1.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTOrganizationNewsViewController.h"
#import "NSUserDefaults+WTAddition.h"
#import "Organization+Addition.h"
#import "WTResourceFactory.h"
#import "Controller+Addition.h"
#import "Object+Addition.h"
#import "News+Addition.h"

@interface WTOrganizationNewsViewController ()

@property (nonatomic, strong) Organization *org;

@end

@implementation WTOrganizationNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"WTNewsViewController" bundle:nibBundleOrNil];
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

+ (WTOrganizationNewsViewController *)createViewControllerWithOrganization:(Organization *)org {
    WTOrganizationNewsViewController *result = [[WTOrganizationNewsViewController alloc] init];
    
    result.org = org;
    
    return result;
}

#pragma mark - Methods to overwrite

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"News" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    NSSortDescriptor *updateTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updatedAt" ascending:YES];
    NSSortDescriptor *publishDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"publishDate" ascending:NO];
    [request setSortDescriptors:@[publishDateDescriptor, updateTimeDescriptor]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"(SELF in %@) AND (SELF in %@)", self.org.publishedNews, [Controller controllerModelForClass:[self class]].hasObjects]];
}

- (void)configureLoadDataRequest:(WTRequest *)request {
    [request getInformationInTypes:[NSUserDefaults getShowAllNewsTypesArray]
                       orderMethod:NewsOrderByPublishDate
                        smartOrder:YES
                              page:self.nextPage
                         byAccount:self.org.identifier];
}

- (void)configureLoadedNews:(News *)news {
    [news setObjectHeldByHolder:[self class]];
}

@end
