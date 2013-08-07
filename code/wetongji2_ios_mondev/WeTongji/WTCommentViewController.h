//
//  WTCommentViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Object;

@interface WTCommentViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *contentBgImageView;
@property (nonatomic, weak) IBOutlet UIView *contentBgView;
@property (nonatomic, weak) IBOutlet UITextView *contentTextView;

+ (void)showViewControllerWithCommentObject:(Object *)commentObject;

@end
