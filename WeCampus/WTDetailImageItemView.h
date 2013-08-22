//
//  WTDetailImageItemView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-20.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTDetailImageItemView;

@protocol WTDetailImageItemViewDelegate <NSObject>

- (void)userTappedDetailImageItemView:(WTDetailImageItemView *)itemView;

@end

@interface WTDetailImageItemView : UIView

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, weak) id<WTDetailImageItemViewDelegate> delegate;

+ (WTDetailImageItemView *)createDetailItemViewWithImageURLString:(NSString *)imageURLString
                                                         delegate:(id<WTDetailImageItemViewDelegate>)delegate;

@end
