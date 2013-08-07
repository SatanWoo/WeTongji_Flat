//
//  WTWaterflowDecorator.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WTWaterflowDecoratorDataSource <NSObject>

- (NSString *)waterflowUnitImageName;
- (UIScrollView *)waterflowScrollView;

@end

@interface WTWaterflowDecorator : NSObject

@property (nonatomic, weak) id<WTWaterflowDecoratorDataSource> dataSource;

+ (WTWaterflowDecorator *)createDecoratorWithDataSource:(id<WTWaterflowDecoratorDataSource>)dataSource;

// Call this method in your UIViewController's |viewWillLayoutSubviews|,
// |viewDidLayoutSubviews| and |scrollViewDidScroll:|.
- (void)adjustWaterflowView;

@end
