//
//  WTSwitch.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-20.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTSwitchScrollView : UIScrollView

@property (nonatomic, strong) IBOutlet UIButton *handlerButton;

@end

@protocol WTSwitchDelegate;

@interface WTSwitch : UIView <UIScrollViewDelegate> {
    BOOL _switchState; // 0 for on, 1 for off
}

@property (nonatomic, strong) IBOutlet UILabel *onLabel;
@property (nonatomic, strong) IBOutlet UILabel *offLabel;
@property (nonatomic, strong) IBOutlet WTSwitchScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *scrollContainerView;
@property (nonatomic, getter = isOn) BOOL on;

@property (nonatomic, weak) id<WTSwitchDelegate> delegate;

+ (WTSwitch *)createSwitchWithDelegate:(id<WTSwitchDelegate>)delegate;

@end

@protocol WTSwitchDelegate <NSObject>

@optional
- (void)switchDidChange:(WTSwitch *)sender;

@end
