//
//  WTDetailDescriptionView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-10.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BillboardPost;
@class OHAttributedLabel;

@interface WTBillboardItemView : UIView

@property (nonatomic, weak) IBOutlet UILabel *plainTitleLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *plainContentLabel;
@property (nonatomic, weak) IBOutlet UILabel *imageTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *plainTextContainerView;
@property (nonatomic, weak) IBOutlet UIView *imageTextContainerView;
@property (nonatomic, weak) IBOutlet UIView *imageContainerView;

+ (WTBillboardItemView *)createLargeItemView;

+ (WTBillboardItemView *)createSmallItemView;

- (void)configureViewWithBillboardPost:(BillboardPost *)post;

- (IBAction)didClickBgButton:(UIButton *)sender;

@end