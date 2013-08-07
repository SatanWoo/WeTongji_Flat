//
//  UIImageView+AsyncLoading.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-19.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "UIImageView+AsyncLoading.h"
#import <WeTongjiSDK/AFNetworking/UIImageView+AFNetworking.h>
#import <WeTongjiSDK/NSUserDefaults+WTSDKAddition.h>

@implementation UIImageView (AsyncLoading)

- (void)loadImageWithImageURLString:(NSString *)imageURLString {
    [self loadImageWithImageURLString:imageURLString success:nil failure:nil];
}

- (void)loadImageWithImageURLString:(NSString *)imageURLString
                            success:(void (^)(UIImage *image))success
                            failure:(void (^)(void))failure {
    
    if (!imageURLString) {
        self.image = nil;
        return;
    }
    
    if ([NSUserDefaults useTestServer]) {
        NSMutableString *testServerImageURLString = [NSMutableString stringWithString:imageURLString];
        [testServerImageURLString replaceOccurrencesOfString:@"we.tongji.edu.cn" withString:@"leiz.name:8080" options:NSLiteralSearch range:NSMakeRange(0, imageURLString.length)];
        imageURLString = testServerImageURLString;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURLString]];
    
    BlockARCWeakSelf weakSelf = self;
    [weakSelf setImageWithURLRequest:request
                    placeholderImage:nil
                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                 
                                 if (success) {
                                     success(image);
                                 } else {
                                     if (weakSelf.image != image) {
                                         weakSelf.image = image;
                                         [self fadeIn];
                                     }
                                 }
                                 
                                 // WTLOG(@"Current disk cache usage:%d", [[NSURLCache sharedURLCache] currentDiskUsage] / 1024);
                                 // WTLOG(@"Current memory cache usage:%d", [[NSURLCache sharedURLCache] currentMemoryUsage] / 1024);
                             }
                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                 // WTLOGERROR(@"Load image:%@", error.localizedDescription);
                                 if (failure)
                                     failure();
                             }];
}

@end
