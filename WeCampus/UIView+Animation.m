//
//  UIView+Animation.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)fadeIn {
    [self fadeInWithCompletion:nil];
}

- (void)fadeInWithCompletion:(void (^)(void))completion {
    self.alpha = 0;
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        
        if (completion) {
            completion();
        }
    }];
}

- (void)fadeOut {
    [self fadeOutWithCompletion:nil];
}

- (void)fadeOutWithCompletion:(void (^)(void))completion {
    self.alpha = 1;
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        
        if (completion) {
            completion();
        }
    }];
}

@end
