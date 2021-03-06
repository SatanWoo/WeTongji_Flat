//
//  UIView+Animation.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)

- (void)fadeIn;
- (void)fadeInWithCompletion:(void (^)(void))completion;
- (void)fadeOut;
- (void)fadeOutWithCompletion:(void (^)(void))completion;

@end
