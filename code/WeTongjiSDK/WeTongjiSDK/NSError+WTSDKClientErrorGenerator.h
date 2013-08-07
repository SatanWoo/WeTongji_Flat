//
//  NSError+WTSDKClientErrorGenerator.h
//  WeTongjiSDK
//
//  Created by 王 紫川 on 13-3-7.
//  Copyright (c) 2013年 WeTongji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (WTSDKClientErrorGenerator)

typedef enum {
    ErrorCodeParamIllegal               = 1,
    ErrorCodeMethodInvalid              = 2,
    ErrorCodeParamInvalid               = 3,
    ErrorCodeSystemParamIncomplete      = 4,
    ErrorCodeNeedUserLogin              = 5,
    ErrorCodeUserSessionExpired         = 6,
    ErrorCodeParamIncomplete            = 7,
    ErrorCodeUserAlreadyRegistered      = 8,
    ErrorCodeUserNameAndNoNotMatching   = 9,
    ErrorCodePasswordFormatInvalid      = 10,
    ErrorCodeAccountNotActivated        = 11,
    ErrorCodeUserNoNotFound             = 12,
    ErrorCodeAccountOrPasswordError     = 13,
    ErrorCodeUserNoHasNoAccount         = 14,
    ErrorCodeFriendInvitationForbidden  = 15,
} WTSDKClientErrorCode;

+ (NSError *)createErrorWithErrorCode:(WTSDKClientErrorCode)errorCode;

@end
