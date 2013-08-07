//
//  WTLikeButtonView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LikeableObject;

@interface WTLikeButtonView : UIView

+ (WTLikeButtonView *)createLikeButtonViewWithObject:(LikeableObject *)object;

- (void)configureViewWithObject:(LikeableObject *)object;

@end
