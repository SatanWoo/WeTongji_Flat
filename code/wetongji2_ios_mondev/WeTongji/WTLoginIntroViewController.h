//
//  WTLoginIntroViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTLoginIntroViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton *tourButton;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *campusInYourPocketLabel;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UIImageView *introBgImageViewA;
@property (nonatomic, weak) IBOutlet UIImageView *introBgImageViewB;

- (IBAction)didClickTourButton:(UIButton *)sender;

- (void)resetFrame:(CGRect)frame;

@end
