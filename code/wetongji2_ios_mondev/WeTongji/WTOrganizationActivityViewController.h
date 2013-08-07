//
//  WTOrganizationActivityViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-6-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTActivityViewController.h"

@class Organization;

@interface WTOrganizationActivityViewController : WTActivityViewController

+ (WTOrganizationActivityViewController *)createViewControllerWithOrganization:(Organization *)org;

@end
