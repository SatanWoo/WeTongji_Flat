//
//  WTElectricityBalanceQueryService.h
//  WeTongjiSDK
//
//  Created by 王 紫川 on 12-11-30.
//  Copyright (c) 2012年 WeTongji. All rights reserved.
//

#import "WTCommon.h"

typedef enum {
    WTElectricityBalanceQueryServiceResultIndexTodayBalance,
    WTElectricityBalanceQueryServiceResultIndexAvarageUse,
} WTElectricityBalanceQueryServiceResultIndex;

@interface WTElectricityBalanceQueryService : NSObject

- (void)getElectricChargeBalanceWithDistrict:(NSString *)district
                                    building:(NSString *)building
                                        room:(NSString *)room
                                successBlock:(WTSuccessCompletionBlock)success
                                failureBlock:(WTFailureCompletionBlock)failure;

+ (WTElectricityBalanceQueryService *)sharedService;

@end
