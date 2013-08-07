//
//  WTNotificationBarButton.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTNotificationBarButton.h"
#import "NSNotificationCenter+WTAddition.h"

static BOOL isNotificationBarButtonShining = NO;

@interface WTNotificationBarButton()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *ringImageView;
@property (nonatomic, strong) UIImageView *shineImageView;
@property (nonatomic, assign, getter = isShining) BOOL shining;
@property (nonatomic, assign, getter = isShineAnimationLocked) BOOL shineAnimationLocked;
@property (nonatomic, assign) SEL targetAction;
@property (nonatomic, weak) id target;

@end

@implementation WTNotificationBarButton

+ (WTNotificationBarButton *)createNotificationBarButtonWithTarget:(id)target
                                                            action:(SEL)action {
    WTNotificationBarButton *result = [[WTNotificationBarButton alloc] init];
    [result setCustomView:result.containerView];
    
    result.target = target;
    result.targetAction = action;
    [result.button addTarget:result action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [NSNotificationCenter registerUserDidCheckNotificationsNotificationWithSelector:@selector(handleUserDidCheckNotificationsNotification:) target:result];
    [NSNotificationCenter registerDidLoadUnreadNotificationsNotificationWithSelector:@selector(handleDidLoadUnreadNotificationsNotification:) target:result];
    
    if (isNotificationBarButtonShining) {
        [result startShine];
    }
    
    return result;
}

#pragma mark - Logic

- (void)performTargetMethod {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.target performSelector:self.targetAction withObject:self];
#pragma clang diagnostic pop
}

#pragma mark - Handle notifications methods

- (void)handleUserDidCheckNotificationsNotification:(NSNotification *)notification {
    [self stopShine];
}

- (void)handleDidLoadUnreadNotificationsNotification:(NSNotification *)notification {
    [self startShine];
}

#pragma mark - Properties

- (void)setSelected:(BOOL)selected {
    [self.button setSelected:!selected];
}

- (BOOL)isSelected {
    return !self.button.isSelected;
}

- (UIImageView *)ringImageView {
    if (_ringImageView == nil) {
        _ringImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTNotificationRing"]];
        _ringImageView.center = CGPointMake(self.button.frame.size.width / 2, self.button.frame.size.height / 2);
        _ringImageView.hidden = YES;
    }
    return _ringImageView;
}

- (UIImageView *)shineImageView {
    if (!_shineImageView) {
        UIImage *shineImage = [UIImage imageNamed:@"WTNotificationShineButton"];
        _shineImageView = [[UIImageView alloc] initWithImage:shineImage];
        _shineImageView.hidden = YES;
    }
    return _shineImageView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        [_containerView resetSize:self.button.frame.size];
        
        [_containerView addSubview:self.button];
        [_containerView addSubview:self.ringImageView];
        [_containerView addSubview:self.shineImageView];
    }
    return _containerView;
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] init];
        UIImage *normalImage = [UIImage imageNamed:@"WTNotificationNormalButton"];
        UIImage *selectImage = [UIImage imageNamed:@"WTNotificationSelectButton"];
        
        /*
         Notice : The selected state is correspondent to the unselected state
         in order to take advantage of the default click effect.
         */
        [_button setBackgroundImage:selectImage forState:UIControlStateNormal];
        [_button setBackgroundImage:normalImage forState:UIControlStateSelected];
        
        _button.adjustsImageWhenHighlighted = NO;
        _button.adjustsImageWhenDisabled = NO;
        
        [_button resetSize:normalImage.size];
        
        _button.selected = YES;
    }
    return _button;
}

#pragma mark - Public methods

- (void)startShine {
    if (self.isSelected)
        return;
    if (self.isShining)
        return;
    self.shining = YES;
    [self startShineAnimation];
    self.shineImageView.hidden = NO;
    isNotificationBarButtonShining = YES;
}

- (void)stopShine {
    self.shineImageView.hidden = YES;
    self.shining = NO;
    isNotificationBarButtonShining = NO;
}

#pragma mark - Action

- (void)didClickButton:(UIButton *)button {
    [self performTargetMethod];
}

#pragma mark - Animation

- (void)startShineAnimation {
    if (!self.isShining)
        return;
    if (self.isShineAnimationLocked)
        return;
    self.ringImageView.hidden = NO;
    self.ringImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    self.ringImageView.alpha = 1;
    
    BlockARCWeakSelf weakSelf = self;
    self.shineAnimationLocked = YES;
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.ringImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 3.0, 3.0);
        weakSelf.ringImageView.alpha = 0;
    } completion:^(BOOL finished) {
        if (weakSelf.isShining) {
            [weakSelf performSelector:@selector(startShineAnimation) withObject:nil afterDelay:0.5];
        } else {
            weakSelf.ringImageView.hidden = YES;
        }
        self.shineAnimationLocked = NO;
    }];
}

@end
