//
//  Advertisement+Addition.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-17.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Advertisement.h"

@interface Advertisement (Addition)

+ (Advertisement *)insertAdvertisement:(NSDictionary *)dict;

+ (Advertisement *)advertisementWithID:(NSString *)adID;

@end
