//
//  WTDetailViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-18.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTLikeButtonView;
@class LikeableObject;

@interface WTDetailViewController : UIViewController

@property (nonatomic, copy) NSString *backBarButtonText;

@property (nonatomic, readonly) WTLikeButtonView *likeButtonContainerView;

- (void)didClickCommentButton:(UIButton *)sender;

- (void)didClickMoreButton:(UIButton *)sender;

- (LikeableObject *)targetObject;

- (BOOL)showMoreNavigationBarButton;

- (BOOL)showLikeNavigationBarButton;

- (NSArray *)imageArrayToShare;

- (NSString *)textToShare;

@end
