//
//  WTErrorHandler.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTErrorHandler.h"
#import <WeTongjiSDK/NSError+WTSDKClientErrorGenerator.h>
#import "UIApplication+WTAddition.h"
#import "WTLoginViewController.h"

@implementation WTErrorHandler 

+ (void)handleError:(NSError *)error {
    // WTLOGERROR(@"%d", error.code);
    if (error.code == ErrorCodeUserSessionExpired || error.code == ErrorCodeNeedUserLogin) {
        [WTLoginViewController showWithIntro:NO];
    } else if (error.code == 4) {
        // 缺少必要的系统参数
    } else if (error.code == -1009) {
        // 网络错误
    } else {
        [[[UIAlertView alloc] initWithTitle:@"请求失败" message:error.localizedDescription delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil] show];
    }
}

@end
