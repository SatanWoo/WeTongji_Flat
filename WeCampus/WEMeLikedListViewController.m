//
//  WEMeLikedListViewController.m
//  WeCampus
//
//  Created by Song on 13-8-28.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEMeLikedListViewController.h"
#import "Organization+Addition.h"
#import "Activity+Addition.h"
#import "User+Addition.h"

@interface WEMeLikedListViewController ()

@end

@implementation WEMeLikedListViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSearchResultWithBlock:(void (^)(int))completion {
    [super clearSearchResultObjects];
    int count;
    count = self.orgsArray.count;
    count += self.actsArray.count;
    count += self.usersArray.count;
    if (completion) {
        completion(count);
    }
}

@end
