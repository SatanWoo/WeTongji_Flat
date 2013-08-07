//
//  WTDragToLoadDecorator.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WTDragToLoadDecoratorDataSource <NSObject>

- (UIScrollView *)dragToLoadScrollView;

@end

@protocol WTDragToLoadDecoratorDelegate <NSObject>

- (void)dragToLoadDecoratorDidDragDown;

@optional
- (void)dragToLoadDecoratorDidDragUp;

@end

@interface WTDragToLoadDecorator : NSObject

@property (nonatomic, weak) id<WTDragToLoadDecoratorDataSource> dataSource;
@property (nonatomic, weak) id<WTDragToLoadDecoratorDelegate> delegate;

@property (nonatomic, assign) BOOL topViewDisabled;
@property (nonatomic, assign) BOOL bottomViewDisabled;

+ (WTDragToLoadDecorator *)createDecoratorWithDataSource:(id<WTDragToLoadDecoratorDataSource>)dataSource
                                                delegate:(id<WTDragToLoadDecoratorDelegate>)delegate
                            bottomActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style;

- (void)setBottomViewDisabled:(BOOL)bottomViewDisabled
                  immediately:(BOOL)immediately;

- (void)topViewLoadFinished:(BOOL)loadSucceeded;

- (void)topViewLoadFinished:(BOOL)loadSucceeded
        animationCompletion:(void (^)(void))completion;

- (void)bottomViewLoadFinished:(BOOL)loadSucceeded;

- (void)setTopViewLoading:(BOOL)animated;

// Call this method in your UIViewController's |viewDidAppear:animated:|.
- (void)startObservingChangesInDragToLoadScrollView;

// Call this method in your UIViewController's |viewDidDisappear:animated:|.
- (void)stopObservingChangesInDragToLoadScrollView;

- (void)scrollViewDidInsertNewCell;

@end

@interface WTDragToLoadDecoratorTopView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *cloudImageView;
@property (nonatomic, weak) IBOutlet UIImageView *dropletImageView;

+ (WTDragToLoadDecoratorTopView *)createTopView;

- (void)startLoadingAnimation;

- (void)stopLoadingAnimation;

- (void)configureCloudAndDropletWithRatio:(float)ratio;

@end

@interface WTDragToLoadDecoratorBottomView : UIView

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

+ (WTDragToLoadDecoratorBottomView *)createBottomView;

@end
