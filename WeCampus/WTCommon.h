//
//  WTCommon.h
//  WeTongjiSDK
//
//  Created by 王 紫川 on 12-12-1.
//  Copyright (c) 2012年 WeTongji. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WTSuccessCompletionBlock)(id responseObject);
typedef void (^WTFailureCompletionBlock)(NSError *error);

#define BlockMRCWeakObject(o) __unsafe_unretained typeof(o)
#define BlockMRCWeakSelf BlockMRCWeakObject(self)

#define BlockARCWeakObject(o) __weak typeof(o)
#define BlockARCWeakSelf BlockARCWeakObject(self)