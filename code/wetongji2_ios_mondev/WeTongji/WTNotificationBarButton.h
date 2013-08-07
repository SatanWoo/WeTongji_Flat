//
//  WTNotificationBarButton.h
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTRootNavigationController.h"

@interface WTNotificationBarButton : UIBarButtonItem

@property (nonatomic, assign, getter = isSelected) BOOL selected;

+ (WTNotificationBarButton *)createNotificationBarButtonWithTarget:(id)target action:(SEL)action;
- (void)startShine;
- (void)stopShine;

@end
