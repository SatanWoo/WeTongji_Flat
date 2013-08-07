//
//  WTWaterflowDecorator.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTWaterflowDecorator.h"

@interface WTWaterflowDecorator ()

@property (nonatomic, strong) UIImageView *waterflowImageViewA;
@property (nonatomic, strong) UIImageView *waterflowImageViewB;

@end

@implementation WTWaterflowDecorator

+ (WTWaterflowDecorator *)createDecoratorWithDataSource:(id<WTWaterflowDecoratorDataSource>)dataSource {
    WTWaterflowDecorator *result = [[WTWaterflowDecorator alloc] init];
    result.dataSource = dataSource;
    return result;
}

#pragma mark - Adjust waterflow view method

- (void)adjustWaterflowView {
    UIImageView *scrollBackgroundViewA = self.waterflowImageViewA;
    UIImageView *scrollBackgroundViewB = self.waterflowImageViewB;
    UIScrollView *scrollView = [self.dataSource waterflowScrollView];
    
    if (!(scrollBackgroundViewA && scrollBackgroundViewB && scrollView))
        return;
    
    CGFloat scrollViewOffsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat scrollViewHeight = scrollView.frame.size.height;
    NSInteger page = scrollViewOffsetY / scrollViewHeight;
    
    UIView *upperView = nil;
    UIView *lowerView = nil;
        
    if (scrollViewOffsetY > 0) {
        if (page % 2 == 0) {
            upperView = scrollBackgroundViewA;
            lowerView = scrollBackgroundViewB;
        } else {
            upperView = scrollBackgroundViewB;
            lowerView = scrollBackgroundViewA;
        }
        [upperView resetOriginY:scrollViewHeight * page - scrollViewOffsetY];
        [lowerView resetOriginY:upperView.frame.origin.y + upperView.frame.size.height];
    } else {
        if (page % 2 == 0) {
            upperView = scrollBackgroundViewB;
            lowerView = scrollBackgroundViewA;
        } else {
            upperView = scrollBackgroundViewA;
            lowerView = scrollBackgroundViewB;
        }
        [lowerView resetOriginY:scrollViewHeight * page - scrollViewOffsetY];
        [upperView resetOriginY:lowerView.frame.origin.y - upperView.frame.size.height];
    }
}

#pragma mark - Help methods

+ (BOOL)view:(UIView *)view containsPoint:(CGFloat)originY {
    return view.frame.origin.y <= originY && view.frame.origin.y + view.frame.size.height > originY;
}

+ (UIImageView *)createWaterflowImageViewWithImageName:(NSString *)imageName frame:(CGRect)frame {
    UIImageView *result = nil;
    result = [[UIImageView alloc] initWithFrame:frame];
    result.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    result.image = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsZero];
    return result;
}

#pragma mark - Properties

- (UIImageView *)waterflowImageViewA {
    if (!_waterflowImageViewA) {
        UIScrollView *scrollView = [self.dataSource waterflowScrollView];
        if (scrollView) {
            _waterflowImageViewA = [WTWaterflowDecorator createWaterflowImageViewWithImageName:[self.dataSource waterflowUnitImageName] frame:scrollView.frame];
            [_waterflowImageViewA resetOriginY:scrollView.contentInset.top];
            [scrollView.superview insertSubview:_waterflowImageViewA atIndex:0];
        }
    }
    return _waterflowImageViewA;
}

- (UIImageView *)waterflowImageViewB {
    if (!_waterflowImageViewB) {
        UIScrollView *scrollView = [self.dataSource waterflowScrollView];
        if (scrollView) {
            _waterflowImageViewB = [WTWaterflowDecorator createWaterflowImageViewWithImageName:[self.dataSource waterflowUnitImageName] frame:scrollView.frame];
            [_waterflowImageViewB resetOriginY:_waterflowImageViewA.frame.origin.y + _waterflowImageViewA.frame.size.height];
            [scrollView.superview insertSubview:_waterflowImageViewB atIndex:0];
        }
    }
    return _waterflowImageViewB;
}

@end
