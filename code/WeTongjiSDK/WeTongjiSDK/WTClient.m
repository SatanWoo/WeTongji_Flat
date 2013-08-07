//
//  WTClient.m
//  WeTongjiSDK
//
//  Created by tang zhixiong on 12-11-7.
//  Copyright (c) 2012年 WeTongji. All rights reserved.
//

#import "WTClient.h"
#import "AFJSONRequestOperation.h"
#import "WTRequest.h"
#import "NSError+WTSDKClientErrorGenerator.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface WTClient()

@property (nonatomic, assign) BOOL usingTestServer;

@end

#define TEST_SERVER_BASE_URL_STRING     @"http://leiz.name:8080"
#define BASE_URL_STRING                 @"http://we.tongji.edu.cn"
#define PATH_STRING                     @"/api/call"

@implementation WTClient

#pragma mark - Constructors

static dispatch_once_t WTClientPredicate;
static WTClient *sharedClient = nil;

+ (WTClient *)sharedClient {
    dispatch_once(&WTClientPredicate, ^{
        sharedClient = [[WTClient alloc] initWithBaseURL:[NSURL URLWithString:[NSUserDefaults useTestServer] ? TEST_SERVER_BASE_URL_STRING : BASE_URL_STRING]];
        sharedClient.usingTestServer = [NSUserDefaults useTestServer];
        
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    });
    
    return sharedClient;
}

+ (void)refreshSharedClient {
    sharedClient = nil;
    WTClientPredicate = 0;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self)
    {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    [self setParameterEncoding:AFFormURLParameterEncoding];
    
    return self;
}

#pragma mark - Public methods

- (void)logout {
    [NSUserDefaults setCurrentUserID:nil session:nil];
}

- (void)enqueueRequest:(WTRequest *)request {
    if (!request.isValid) {
        request.failureCompletionBlock(request.error);
        return;
    }
    AFHTTPRequestOperation *operation = [self generateRequestOperationWithRawRequest:request];
    [self enqueueHTTPRequestOperation:operation];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
}

#pragma mark - Logic methods

- (NSMutableURLRequest *)generateURLRequestWithRawRequest:(WTRequest *)rawRequest {
    
    NSMutableURLRequest *URLRequest;
    NSString *HTTPMethod = rawRequest.HTTPMethod;
    NSDictionary *params = rawRequest.params;
    
    NSTimeInterval timeOutInterval = 20.0;
    
    if([HTTPMethod isEqualToString:HttpMethodGET]) {
        
        URLRequest = [self requestWithMethod:HTTPMethod
                                        path:PATH_STRING
                                  parameters:params];
        
    } else if([HTTPMethod isEqualToString:HttpMethodPOST]) {
        
        NSString *queryString= rawRequest.queryString;
        NSDictionary *postValue = rawRequest.postValue;
        URLRequest= [self requestWithMethod:HTTPMethod
                                       path:[NSString stringWithFormat:@"%@?%@", PATH_STRING, queryString]
                                 parameters:postValue];
        
    } else if([HTTPMethod isEqualToString:HttpMethodUpLoadImage]) {
        
        NSData *imageData = UIImageJPEGRepresentation(rawRequest.uploadImage, 1.0f);
        NSString *queryString= rawRequest.queryString;
        URLRequest = [self multipartFormRequestWithMethod:HttpMethodPOST
                                                     path:[NSString stringWithFormat:@"%@?%@", PATH_STRING, queryString]
                                               parameters:nil
                                constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                    if (imageData) {
                                        [formData appendPartWithFileData:imageData
                                                                    name:@"Image"
                                                                fileName:@"avatar.jpg"
                                                                mimeType:@"image/jpeg"];
                                    }
                                }];
        timeOutInterval = 40.0;
    }
    // 设置超时时间
    [URLRequest setTimeoutInterval:timeOutInterval];
    
    NSLog(@"%@", URLRequest);
    NSLog(@"%@", [[NSString alloc] initWithData:[URLRequest HTTPBody] encoding:self.stringEncoding]);
    
    return URLRequest;
}

- (AFHTTPRequestOperation *)generateRequestOperationWithURLRequest:(NSMutableURLRequest *)URLRequest rawRequest:(WTRequest *)rawRequest {
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:URLRequest success:^(AFHTTPRequestOperation *operation, id resposeObject) {
        NSDictionary *status = resposeObject[@"Status"];
        NSString *statusIDString = status[@"Id"];
        NSInteger statusID = statusIDString.integerValue;
        NSDictionary *result = resposeObject[@"Data"];
        
        if(result && statusID == 0) {
            if (rawRequest.preSuccessCompletionBlock) {
                rawRequest.preSuccessCompletionBlock(result);
            }
            if(rawRequest.successCompletionBlock) {
                rawRequest.successCompletionBlock(result);
            }
        } else {
            NSError *error = [NSError createErrorWithErrorCode:statusID];
            if (!error) {
                NSString *errorDesc = [NSString stringWithFormat:@"%@", status[@"Memo"]];
                error = [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier
                                            code:statusID
                                        userInfo:@{@"NSLocalizedDescription" : errorDesc}];
                
                NSLog(@"Server responsed error code:%d\n\
                      desc: %@\n", statusID, errorDesc);
            }
            
            if(rawRequest.failureCompletionBlock) {
                rawRequest.failureCompletionBlock(error);
            }
        }
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(rawRequest.failureCompletionBlock) {
            rawRequest.failureCompletionBlock(error);
        }
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
    }];
    
    return operation;
}

- (AFHTTPRequestOperation *)generateRequestOperationWithRawRequest:(WTRequest *)rawRequest {
    NSMutableURLRequest *URLRequest = [self generateURLRequestWithRawRequest:rawRequest];
    AFHTTPRequestOperation *operation = [self generateRequestOperationWithURLRequest:URLRequest rawRequest:rawRequest];
    return operation;
}

@end
