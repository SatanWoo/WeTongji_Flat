//
//  UIImageView+AsyncLoading.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-19.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (AsyncLoading)

- (void)loadImageWithImageURLString:(NSString *)imageURLString;

- (void)loadImageWithImageURLString:(NSString *)imageURLString
                            success:(void (^)(UIImage *image))success
                            failure:(void (^)(void))failure;

@end
