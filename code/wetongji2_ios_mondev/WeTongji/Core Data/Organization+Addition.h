//
//  Organization+Addition.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Organization.h"

@interface Organization (Addition)

+ (Organization *)insertOrganization:(NSDictionary *)dict;

+ (Organization *)organizationWithID:(NSString *)orgID;

@end
