//
//  WTLocationManager.m
//  WeTongji
//
//  Created by 王 紫川 on 13-6-5.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface WTLocationManager ()

@property (nonatomic, strong) CLLocationManager *locationMananger;

@end

@implementation WTLocationManager

#pragma mark - Constructors

+ (WTLocationManager *)sharedManager {
    static WTLocationManager *manager = nil;
    static dispatch_once_t WTLocationManagerPredicate;
    dispatch_once(&WTLocationManagerPredicate, ^{
        manager = [[WTLocationManager alloc] init];
    });
    
    return manager;
}
@end
