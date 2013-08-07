//
//  WTResourceFactory.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTResourceFactory.h"

#define BUTTON_WIDTH_INCREMENT      30.0f
#define MIN_BACK_BAR_BUTTON_WIDTH   59.0f
#define MAX_BACK_BAR_BUTTON_WIDTH   100.0f

@implementation WTResourceFactory

+ (UIButton *)createDisableButtonWithText:(NSString *)text {
    UIButton *button = [[UIButton alloc] init];
    [WTResourceFactory configureDisableButton:button text:text];
    button.selected = YES;
    button.userInteractionEnabled = NO;
    return button;
}

+ (UIBarButtonItem *)createAddFriendBarButtonWithTarget:(id)target
                                                 action:(SEL)action {
    UIButton *addFriendButton = [WTResourceFactory createAddFriendButtonWithTarget:target action:action];
    UIBarButtonItem *result = [WTResourceFactory createBarButtonWithButton:addFriendButton];
    return result;
}

+ (UIButton *)createAddFriendButtonWithTarget:(id)target
                                       action:(SEL)action {
    UIButton *button = [WTResourceFactory createNormalButtonWithText:@""];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIImage *addFriendNormalIconImage = nil;
    UIImage *addFriendSelectIconImage = nil;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"zh-Hans"]) {
        addFriendNormalIconImage = [UIImage imageNamed:@"WTAddFriendSelectIconCN"];
        addFriendSelectIconImage = [UIImage imageNamed:@"WTAddFriendNormalIconCN"];
    } else {
        addFriendNormalIconImage = [UIImage imageNamed:@"WTAddFriendSelectIconEN"];
        addFriendSelectIconImage = [UIImage imageNamed:@"WTAddFriendNormalIconEN"];
    }
    [button setImage:addFriendNormalIconImage forState:UIControlStateNormal];
    [button setImage:addFriendNormalIconImage forState:UIControlStateHighlighted];
    
    [button setImage:addFriendSelectIconImage forState:UIControlStateSelected];
    [button resetWidth:74.0f];
    
    return button;
}

+ (UIBarButtonItem *)createSettingBarButtonWithTarget:(id)target
                                               action:(SEL)action {
    UIButton *button = [WTResourceFactory createNormalButtonWithText:@""];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIImage *newPostNormalIconImage = [UIImage imageNamed:@"WTSettingSelectIcon"];
    [button setImage:newPostNormalIconImage forState:UIControlStateNormal];
    [button setImage:newPostNormalIconImage forState:UIControlStateHighlighted];
    UIImage *newPostSelectIconImage = [UIImage imageNamed:@"WTSettingNormalIcon"];
    [button setImage:newPostSelectIconImage forState:UIControlStateSelected];
    
    [button resetWidth:38.0f];
    return [WTResourceFactory createBarButtonWithButton:button];
}

+ (UIBarButtonItem *)createNewPostBarButtonWithTarget:(id)target
                                               action:(SEL)action {
    UIButton *button = [WTResourceFactory createNormalButtonWithText:@""];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIImage *newPostNormalIconImage = [UIImage imageNamed:@"WTNewPostSelectIcon"];
    [button setImage:newPostNormalIconImage forState:UIControlStateNormal];
    [button setImage:newPostNormalIconImage forState:UIControlStateHighlighted];
    UIImage *newPostSelectIconImage = [UIImage imageNamed:@"WTNewPostNormalIcon"];
    [button setImage:newPostSelectIconImage forState:UIControlStateSelected];
    
    [button resetWidth:38.0f];
    return [WTResourceFactory createBarButtonWithButton:button];
}

+ (UIBarButtonItem *)createFilterBarButtonWithTarget:(id)target
                                              action:(SEL)action
                                               focus:(BOOL)focus {
    UIButton *button =  focus ? [WTResourceFactory createFocusButtonWithText:@""] : [WTResourceFactory createNormalButtonWithText:@""];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIImage *filterNormalIconImage = [UIImage imageNamed:@"WTFilterSelectIcon"];
    [button setImage:filterNormalIconImage forState:UIControlStateNormal];
    [button setImage:filterNormalIconImage forState:UIControlStateHighlighted];
    UIImage *filterSelectIconImage = focus ? [UIImage imageNamed:@"WTFilterSelectIcon"] : [UIImage imageNamed:@"WTFilterNormalIcon"];
    [button setImage:filterSelectIconImage forState:UIControlStateSelected];
    
    [button resetWidth:filterNormalIconImage.size.width];
    return [WTResourceFactory createBarButtonWithButton:button];
}

#define MAX_NAVIGATION_BAR_TITLE_VIEW_WIDTH 140.0f

+ (UIView *)createNavigationBarTitleViewWithText:(NSString *)text {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.shadowColor = [UIColor whiteColor];
    titleLabel.shadowOffset = CGSizeMake(0, 1);
    titleLabel.text = text;
    [titleLabel sizeToFit];
    
    if (titleLabel.frame.size.width > MAX_NAVIGATION_BAR_TITLE_VIEW_WIDTH)
        [titleLabel resetWidth:MAX_NAVIGATION_BAR_TITLE_VIEW_WIDTH];
    
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [titleLabel setMinimumFontSize:12.0f];
    
    UIView *titleContainerView = [[UIView alloc] initWithFrame:titleLabel.frame];
    [titleLabel resetOriginY:0];
    [titleContainerView addSubview:titleLabel];
    
    return titleContainerView;
}

+ (UIBarButtonItem *)createNormalBarButtonWithText:(NSString *)text
                                            target:(id)target
                                            action:(SEL)action {
    UIButton *button = [WTResourceFactory createNormalButtonWithText:text];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [WTResourceFactory createBarButtonWithButton:button];
}

+ (UIBarButtonItem *)createFocusBarButtonWithText:(NSString *)text
                                           target:(id)target
                                           action:(SEL)selector {
    UIButton *button = [WTResourceFactory createFocusButtonWithText:text];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return [WTResourceFactory createBarButtonWithButton:button];
}

+ (UIBarButtonItem *)createLogoBackBarButtonWithTarget:(id)target action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0, 8.0, 0.0, 6.0);
    UIImage *barBarNormalButtonImage = [[UIImage imageNamed:@"WTNavigationBarBackNormalButton"] resizableImageWithCapInsets:insets];
    [button setBackgroundImage:barBarNormalButtonImage forState:UIControlStateNormal];
    
    UIImage *barBarHighlightButtonImage = [[UIImage imageNamed:@"WTNavigationBarBackHighlightButton"] resizableImageWithCapInsets:insets];
    [button setBackgroundImage:barBarHighlightButtonImage forState:UIControlStateHighlighted];
    
    UIImage *backBarNormalButtonLogoImage = [UIImage imageNamed:@"WTNavigationBarBackNormalButtonIcon"];
    [button setImage:backBarNormalButtonLogoImage forState:UIControlStateNormal];
    
    UIImage *backBarHighlightButtonLogoImage = [UIImage imageNamed:@"WTNavigationBarBackHighlightButtonIcon"];
    [button setImage:backBarHighlightButtonLogoImage forState:UIControlStateHighlighted];
    
    [button resetSize:backBarNormalButtonLogoImage.size];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [WTResourceFactory createBarButtonWithButton:button];
}

+ (UIBarButtonItem *)createBackBarButtonWithText:(NSString *)text
                                          target:(id)target
                                          action:(SEL)action {
    return [WTResourceFactory createBackBarButtonWithText:text
                                                   target:target
                                                   action:action
                                       restrictToMaxWidth:YES];
}

+ (UIBarButtonItem *)createBackBarButtonWithText:(NSString *)text
                                          target:(id)target
                                          action:(SEL)action
                              restrictToMaxWidth:(BOOL)restrictToMaxWidth {
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:text forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 14.0f, 0, 8.0f);
    
    UIEdgeInsets bgImageEdgeInsets = UIEdgeInsetsMake(0.0, 14.0, 0.0, 6.0);
    UIImage *barBarNormalButtonImage = [[UIImage imageNamed:@"WTNavigationBarBackNormalButton"] resizableImageWithCapInsets:bgImageEdgeInsets];
    [button setBackgroundImage:barBarNormalButtonImage forState:UIControlStateNormal];
    
    UIImage *barBarHighlightButtonImage = [[UIImage imageNamed:@"WTNavigationBarBackHighlightButton"] resizableImageWithCapInsets:bgImageEdgeInsets];
    [button setBackgroundImage:barBarHighlightButtonImage forState:UIControlStateHighlighted];
    
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    CGFloat titleLabelWidth = [text sizeWithFont:button.titleLabel.font].width + BUTTON_WIDTH_INCREMENT;
    titleLabelWidth = titleLabelWidth < MIN_BACK_BAR_BUTTON_WIDTH ? MIN_BACK_BAR_BUTTON_WIDTH : titleLabelWidth;
    if (restrictToMaxWidth)
        titleLabelWidth = titleLabelWidth > MAX_BACK_BAR_BUTTON_WIDTH ? MAX_BACK_BAR_BUTTON_WIDTH : titleLabelWidth;
    
    [button resetSize:CGSizeMake(titleLabelWidth, barBarNormalButtonImage.size.height)];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [WTResourceFactory createBarButtonWithButton:button];
}

+ (UIBarButtonItem *)createBarButtonWithButton:(UIButton *)button {
    UIView *containerView = [[UIView alloc] initWithFrame:button.frame];
    [button resetOrigin:CGPointMake(0, 1)];
    [containerView addSubview:button];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    return barBtnItem;
}

+ (UIButton *)createNormalButtonWithText:(NSString *)text {
    UIButton *button = [[UIButton alloc] init];
    [WTResourceFactory configureNormalButton:button text:text];
    button.selected = YES;
    return button;
}

+ (UIButton *)createTranslucentButtonWithText:(NSString *)text {
    UIButton *button = [[UIButton alloc] init];
    [WTResourceFactory configureTranslucentButton:button text:text];
    return button;
}

+ (UIButton *)createFocusButtonWithText:(NSString *)text {
    UIButton *button = [[UIButton alloc] init];
    [WTResourceFactory configureFocusButton:button text:text];
    button.selected = YES;
    return button;
}

+ (void)configureDisableButton:(UIButton *)button
                          text:(NSString *)text {
    [WTResourceFactory configureButton:button
                                  text:text
                           normalImage:[UIImage imageNamed:@"WTDisableButton"]
                        highlightImage:[UIImage imageNamed:@"WTDisableButton"]
                           selectImage:[UIImage imageNamed:@"WTDisableButton"]
                      normalTitleColor:[UIColor colorWithRed:159.0f / 255 green:159.0f / 255 blue:159.0f / 255 alpha:1.0f]
                     normalShadowColor:[UIColor clearColor]
                   highlightTitleColor:[UIColor colorWithRed:159.0f / 255 green:159.0f / 255 blue:159.0f / 255 alpha:1.0f]
                  highlightShadowColor:[UIColor clearColor]
                      selectTitleColor:[UIColor colorWithRed:159.0f / 255 green:159.0f / 255 blue:159.0f / 255 alpha:1.0f]
                     selectShadowColor:[UIColor clearColor]];
}
+ (void)configureFocusButton:(UIButton *)button
                        text:(NSString *)text {
    [WTResourceFactory configureButton:button
                                  text:text
                           normalImage:[UIImage imageNamed:@"WTSelectButton"]
                        highlightImage:[UIImage imageNamed:@"WTSelectButton"]
                           selectImage:[UIImage imageNamed:@"WTFocusButton"]
                      normalTitleColor:[UIColor whiteColor]
                     normalShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f]
                   highlightTitleColor:[UIColor whiteColor]
                  highlightShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f]
                      selectTitleColor:[UIColor whiteColor]
                     selectShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f]];
}

+ (void)configureNormalButton:(UIButton *)button
                         text:(NSString *)text {
    [WTResourceFactory configureButton:button
                                  text:text
                           normalImage:[UIImage imageNamed:@"WTSelectButton"]
                        highlightImage:[UIImage imageNamed:@"WTSelectButton"]
                           selectImage:[UIImage imageNamed:@"WTNormalButton"]
                      normalTitleColor:[UIColor whiteColor]
                     normalShadowColor:[UIColor grayColor]
                   highlightTitleColor:[UIColor whiteColor]
                  highlightShadowColor:[UIColor grayColor]
                      selectTitleColor:[UIColor darkGrayColor]
                     selectShadowColor:[UIColor whiteColor]];
}

+ (void)configureTranslucentButton:(UIButton *)button
                              text:(NSString *)text {
    [WTResourceFactory configureButton:button
                                  text:text
                           normalImage:[UIImage imageNamed:@"WTTranslucentNormalButton"]
                        highlightImage:[UIImage imageNamed:@"WTTranslucentHighlightButton"]
                           selectImage:nil
                      normalTitleColor:[UIColor whiteColor]
                     normalShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f]
                   highlightTitleColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f]
                  highlightShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]
                      selectTitleColor:nil
                     selectShadowColor:nil];
}

+ (void)configureButton:(UIButton *)button
                   text:(NSString *)text
            normalImage:(UIImage *)normalImage
         highlightImage:(UIImage *)highlightImage
            selectImage:(UIImage *)selectImage
       normalTitleColor:(UIColor *)normalTitleColor
      normalShadowColor:(UIColor *)normalShadowColor
    highlightTitleColor:(UIColor *)highlightTitleColor
   highlightShadowColor:(UIColor *)highlightShadowColor
       selectTitleColor:(UIColor *)selectTitleColor
      selectShadowColor:(UIColor *)selectShadowColor {
    
    button.adjustsImageWhenHighlighted = NO;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0);
    if (normalImage) {
        UIImage *resizableNormalImage = [normalImage resizableImageWithCapInsets:insets];
        [button setBackgroundImage:resizableNormalImage forState:UIControlStateNormal];
    }
    
    if (highlightImage) {
        UIImage *resizableHighlightImage = [highlightImage resizableImageWithCapInsets:insets];
        [button setBackgroundImage:resizableHighlightImage forState:UIControlStateHighlighted];
    }
    
    if (selectImage) {
        UIImage *resizableSelectImage = [selectImage resizableImageWithCapInsets:insets];
        [button setBackgroundImage:resizableSelectImage forState:UIControlStateSelected];
    }
    
    if (normalTitleColor)
        [button setTitleColor:normalTitleColor forState:UIControlStateNormal];
    
    if (normalShadowColor)
        [button setTitleShadowColor:normalShadowColor forState:UIControlStateNormal];
    
    if (highlightTitleColor)
        [button setTitleColor:highlightTitleColor forState:UIControlStateHighlighted];
    
    if (highlightShadowColor)
        [button setTitleShadowColor:highlightShadowColor forState:UIControlStateHighlighted];
    
    if (selectTitleColor)
        [button setTitleColor:selectTitleColor forState:UIControlStateSelected];
    
    if (selectShadowColor)
        [button setTitleShadowColor:selectShadowColor forState:UIControlStateSelected];
    
    [button setTitle:text forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
    
    CGFloat titleLabelWidth = [text sizeWithFont:button.titleLabel.font].width;
    [button resetSize:CGSizeMake(titleLabelWidth + BUTTON_WIDTH_INCREMENT, normalImage.size.height)];
}

+ (UIView *)createPlaceholderViewWithScrollView:(UIScrollView *)scrollView {
    UIView *result = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIImage *placeholderImage = [UIImage imageNamed:@"WTBluePlaceholderImage.jpg"];
    result.backgroundColor = [UIColor colorWithPatternImage:placeholderImage];
    [result setAutoresizingMask:UIViewAutoresizingNone];
    [result resetOriginY:-result.frame.size.height - scrollView.contentInset.top];
    
    UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTScrollViewPlaceholderShadowUnit"]];
    [shadowImageView resetOriginY:result.frame.size.height - shadowImageView.frame.size.height];
    [shadowImageView resetWidth:320.0f];
    [result addSubview:shadowImageView];
    
    return result;
}

+ (UIButton *)createLockButtonWithTarget:(id)target
                                  action:(SEL)action {
    UIButton *button = [WTResourceFactory createNormalButtonWithText:@""];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *lockNormalIconImage = [UIImage imageNamed:@"WTLockHighlightIcon"];
    [button setImage:lockNormalIconImage forState:UIControlStateNormal];
    [button setImage:lockNormalIconImage forState:UIControlStateHighlighted];
    UIImage *lockSelectIconImage = [UIImage imageNamed:@"WTLockNormalIcon"];
    [button setImage:lockSelectIconImage forState:UIControlStateSelected];
    
    [button resetWidth:lockNormalIconImage.size.width];
    return button;
}

+ (void)configureActivityIndicatorBarButton:(UIBarButtonItem *)barButtonItem
                     activityIndicatorStyle:(UIActivityIndicatorViewStyle)style {
    UIView *buttonContainerView = barButtonItem.customView;
    for (UIView *subview in buttonContainerView.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setImage:nil forState:UIControlStateNormal];
            [button setImage:nil forState:UIControlStateHighlighted];
            [button setImage:nil forState:UIControlStateSelected];
            [button setTitle:@"" forState:UIControlStateNormal];
            break;
        }
    }
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    activityIndicator.center = CGPointMake(buttonContainerView.frame.size.width / 2, buttonContainerView.frame.size.height / 2);
    [buttonContainerView addSubview:activityIndicator];
    buttonContainerView.userInteractionEnabled = NO;
    [activityIndicator startAnimating];
}

+ (void)configureActivityIndicatorButton:(UIButton *)button
                  activityIndicatorStyle:(UIActivityIndicatorViewStyle)style {
    [button setImage:nil forState:UIControlStateNormal];
    [button setImage:nil forState:UIControlStateHighlighted];
    [button setImage:nil forState:UIControlStateSelected];
    [button setTitle:@"" forState:UIControlStateNormal];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    activityIndicator.center = CGPointMake(button.frame.size.width / 2, button.frame.size.height / 2);
    [button addSubview:activityIndicator];
    button.userInteractionEnabled = NO;
    [activityIndicator startAnimating];
}

@end
