//
//  WTOrganizationNewsViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-1.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNewsViewController.h"

@class Organization;

@interface WTOrganizationNewsViewController : WTNewsViewController

+ (WTOrganizationNewsViewController *)createViewControllerWithOrganization:(Organization *)org;

@end
