//
//  WTLikeListViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTLikeListViewController.h"
#import "WTDragToLoadDecorator.h"
#import "WTResourceFactory.h"
#import "Object+Addition.h"

#import "News+Addition.h"
#import "Activity+Addition.h"
#import "Star+Addition.h"
#import "Organization+Addition.h"
#import "Controller+Addition.h"
#import "User+Addition.h"

@interface WTLikeListViewController () <WTDragToLoadDecoratorDataSource, WTDragToLoadDecoratorDelegate>

@property (nonatomic, copy) NSString *likeObjectClass;
@property (nonatomic, copy) NSString *backButtonText;
@property (nonatomic, strong) WTDragToLoadDecorator *dragToLoadDecorator;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) NSInteger nextPage;

@end

@implementation WTLikeListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.nextPage = 2;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureNavigationBar];
    [self configureDragToLoadDecorator];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.dragToLoadDecorator startObservingChangesInDragToLoadScrollView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.dragToLoadDecorator stopObservingChangesInDragToLoadScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

+ (WTLikeListViewController *)createViewControllerWithUser:(User *)user
                                           likeObjectClass:(NSString *)likeObjectClass
                                            backButtonText:(NSString *)backButtonText {
    WTLikeListViewController *result = [[WTLikeListViewController alloc] init];
    
    result.user = user;
    
    result.likeObjectClass = likeObjectClass;
    
    result.backButtonText = backButtonText;
    
    return result;
}

#pragma mark - Data load methods

- (void)loadMoreDataWithSuccessBlock:(void (^)(void))success
                        failureBlock:(void (^)(void))failure {
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        WTLOG(@"Get liked objects list: %@", responseData);
        
        NSDictionary *resultDict = (NSDictionary *)responseData;
        NSString *nextPage = resultDict[@"NextPager"];
        self.nextPage = nextPage.integerValue;
        
        if (self.nextPage == 0) {
            [self.dragToLoadDecorator setBottomViewDisabled:YES];
        } else {
            [self.dragToLoadDecorator setBottomViewDisabled:NO];
        }
        
        if (success)
            success();
        
        NSArray *likedObjectsInfoArray = resultDict[@"Like"];
        for (NSDictionary *likedObjectInfo in likedObjectsInfoArray) {
            
            NSDictionary *modelDetailsInfo = likedObjectInfo[@"ModelDetails"];
            if (modelDetailsInfo.count == 0)
                continue;
            
            NSString *modelType = [NSString stringWithFormat:@"%@", likedObjectInfo[@"Model"]];
            
            if ([modelType isEqualToString:@"Activity"]) {
                Activity *activity = [Activity insertActivity:modelDetailsInfo];
                [activity setObjectHeldByHolder:[self class]];
            } else if ([modelType isEqualToString:@"Information"]) {
                News *news = [News insertNews:modelDetailsInfo];
                [news setObjectHeldByHolder:[self class]];
            } else if ([modelType isEqualToString:@"Person"]) {
                Star *star = [Star insertStar:modelDetailsInfo];
                [star setObjectHeldByHolder:[self class]];
            } else if ([modelType isEqualToString:@"Account"]) {
                Organization *org = [Organization insertOrganization:modelDetailsInfo];
                [org setObjectHeldByHolder:[self class]];
            } else if ([modelType isEqualToString:@"User"]) {
                User *user = [User insertUser:modelDetailsInfo];
                [user setObjectHeldByHolder:[self class]];
            }
        }
        
    } failureBlock:^(NSError * error) {
        WTLOGERROR(@"Get liked objects list:%@", error.localizedDescription);
        
        if (failure)
            failure();
        
        [WTErrorHandler handleError:error];
    }];
    [request getLikedObjectsListWithModel:[Object convertObjectClassToModelType:self.likeObjectClass] page:self.nextPage];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)clearOutdatedData {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:self.likeObjectClass inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"SELF in %@ AND updatedAt < %@", self.user.likedObjects, [NSDate dateWithTimeIntervalSinceNow:-1]]];
    NSArray *result = [[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:nil];
    for (LikeableObject *object in result) {
        [self.user removeLikedObjectsObject:object];
        [object setObjectFreeFromHolder:[self class]];
    }
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    UIBarButtonItem *cancalBarButtonItem = [WTResourceFactory createBackBarButtonWithText:self.backButtonText target:self action:@selector(didClickCancelButton:)];
    self.navigationItem.leftBarButtonItem = cancalBarButtonItem;
    
    NSString *objectClassString = nil;
    if ([self.likeObjectClass isEqualToString:@"BillboardPost"]) {
        objectClassString = @"Billboard";
    } else {
        objectClassString = NSLocalizedString(self.likeObjectClass, nil);
    }
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:objectClassString];
}

- (void)configureDragToLoadDecorator {
    self.dragToLoadDecorator = [WTDragToLoadDecorator createDecoratorWithDataSource:self delegate:self bottomActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

#pragma mark - Actions

- (void)didClickCancelButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CoreDataTableViewController methods

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:self.likeObjectClass inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"objectClass" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"(objectClass == %@) AND (SELF in %@) AND (SELF in %@)", self.likeObjectClass, self.user.likedObjects, [Controller controllerModelForClass:[self class]].hasObjects]];
}

- (void)fetchedResultsControllerDidPerformFetch {
    if ([self.fetchedResultsController.sections.lastObject numberOfObjects] == 0) {
        [self.dragToLoadDecorator setTopViewLoading:YES];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = [super detailViewControllerForIndexPath:indexPath];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WTDragToLoadDecoratorDataSource

- (UIScrollView *)dragToLoadScrollView {
    return self.tableView;
}

#pragma mark - WTDragToLoadDecoratorDelegate

- (void)dragToLoadDecoratorDidDragDown {
    self.nextPage = 1;
    [self loadMoreDataWithSuccessBlock:^{
        [self clearOutdatedData];
        [self.dragToLoadDecorator topViewLoadFinished:YES];
    } failureBlock:^{
        [self.dragToLoadDecorator topViewLoadFinished:NO];
    }];
}

- (void)dragToLoadDecoratorDidDragUp {
    [self loadMoreDataWithSuccessBlock:^{
        [self.dragToLoadDecorator bottomViewLoadFinished:YES];
    } failureBlock:^{
        [self.dragToLoadDecorator bottomViewLoadFinished:NO];
    }];
}

@end
