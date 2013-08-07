//
//  WTSwitch.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-20.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTSwitch.h"
#import <QuartzCore/QuartzCore.h>

@interface WTSwitch ()

@end

@implementation WTSwitch

+ (WTSwitch *)createSwitchWithDelegate:(id<WTSwitchDelegate>)delegate {
    WTSwitch *result = [[[NSBundle mainBundle] loadNibNamed:@"WTSwitch" owner:self options:nil] lastObject];
    result.delegate = delegate;
    return result;
}

- (void)awakeFromNib {
    self.scrollView.layer.masksToBounds = YES;
    self.scrollView.layer.cornerRadius = 14.0f;
    self.scrollView.contentSize = CGSizeMake(128, self.scrollView.frame.size.height * 3);
    self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
    
    self.onLabel.text = NSLocalizedString(@"ON", nil);
    self.offLabel.text = NSLocalizedString(@"OFF", nil);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    [self addGestureRecognizer:tap];
}

#pragma mark - Properties

- (BOOL)isOn {
    return (_switchState == 0);
}

- (void)setOn:(BOOL)on {
    _switchState = !on;
    if (on)
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
    else {
        self.scrollView.contentOffset = CGPointMake(50, self.scrollView.frame.size.height);
        [self.scrollView.handlerButton resetCenterX:64 - self.scrollView.contentOffset.x];
    }
}

#pragma mark - Gesture handler

- (void)didTapView:(UITapGestureRecognizer *)gesture {
    self.scrollView.handlerButton.highlighted = NO;
    
    CGPoint location = [gesture locationInView:self.scrollView];
    if (location.x < 50) {
        [UIView animateWithDuration:0.25f animations:^{
            self.scrollView.contentOffset = CGPointMake(50, self.scrollView.frame.size.height);
        } completion:^(BOOL finished) {
            //_switchState = 1;
            [self.delegate switchDidChange:self];
        }];
    } else if (location.x > 78) {
        [UIView animateWithDuration:0.25f animations:^{
            self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
        } completion:^(BOOL finished) {
            //_switchState = 0;
            [self.delegate switchDidChange:self];
        }];
    } else {
        [UIView animateWithDuration:0.25f animations:^{
            self.scrollView.contentOffset = _switchState ? CGPointMake(0, self.scrollView.frame.size.height) : CGPointMake(50, self.scrollView.frame.size.height);
        } completion:^(BOOL finished) {
            //_switchState = !_switchState;
            [self.delegate switchDidChange:self];
        }];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, self.scrollView.frame.size.height);
    [self.scrollView.handlerButton resetCenterX:64 - scrollView.contentOffset.x];
    
    _switchState = (scrollView.contentOffset.x >= 50);
    
    if (self.scrollView.dragging && !self.scrollView.isDecelerating) {
        // NSLog(@"dragging not decelerating, highlight");
        self.scrollView.handlerButton.highlighted = YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.scrollView.handlerButton.highlighted = NO;
    // NSLog(@"end dragging, not highlight");
    [self.delegate switchDidChange:self];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.scrollView.handlerButton.highlighted = NO;
    // NSLog(@"end decelerating, not highlight");
    [self.delegate switchDidChange:self];
}

@end

@implementation WTSwitchScrollView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        // NSLog(@"inside point %@", NSStringFromCGPoint(point));
        // self.handlerButton.highlighted = YES;
        return self;
    }
    else {
        // NSLog(@"outside point %@", NSStringFromCGPoint(point));
        return [super hitTest:point withEvent:event];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // NSLog(@"touchesBegan");
    self.handlerButton.highlighted = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // NSLog(@"touchesEnded");
    self.handlerButton.highlighted = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // NSLog(@"touchesCancelled");
    self.handlerButton.highlighted = NO;
}

@end
