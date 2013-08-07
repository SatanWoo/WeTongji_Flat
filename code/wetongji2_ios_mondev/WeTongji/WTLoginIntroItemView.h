//
//  WTLoginIntroItemView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-6.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTLoginIntroItemView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *label;

+ (WTLoginIntroItemView *)createViewWithImage:(UIImage *)image
                                         text:(NSString *)text;

@end
