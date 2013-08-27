//
//  WUSwitch.h
//  WUSwitchDemo
//
//  Created by Ziqi Wu on 27/08/13.
//  Copyright (c) 2013 Tongji University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WUSwitch : UIControl

@property(nonatomic, retain) UIColor *tintColor;
@property(nonatomic, retain) UIColor *onTintColor;
@property(nonatomic, assign) UIColor *offTintColor;
@property(nonatomic, assign) UIColor *thumbTintColor;

@property(nonatomic,getter=isOn) BOOL on;

- (id)initWithFrame:(CGRect)frame;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
