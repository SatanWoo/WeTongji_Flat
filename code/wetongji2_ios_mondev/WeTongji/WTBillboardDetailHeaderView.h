//
//  WTBillboardDetailHeaderView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-24.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OHAttributedLabel;
@class BillboardPost;

@interface WTBillboardDetailAuthorView : UIView

@property (nonatomic, weak) IBOutlet UILabel *authorNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIView *avatarContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;

+ (WTBillboardDetailAuthorView *)createAuthorView;

- (void)configureViewWithBillboardPost:(BillboardPost *)post;

@end

@interface WTBillboardDetailHeaderView : UIView

@property (nonatomic, weak) UIView *postContentView;
@property (nonatomic, readonly) WTBillboardDetailAuthorView *authorView;

+ (WTBillboardDetailHeaderView *)createDetailHeaderViewWithBillboardPost:(BillboardPost *)post;

@end

@interface WTImageBillboardDetailHeaderView : UIView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *postImageView;
@property (nonatomic, weak) IBOutlet UIView *postImageContainerView;

+ (WTImageBillboardDetailHeaderView *)createDetailHeaderView;

- (void)configureViewWithBillboardPost:(BillboardPost *)post;

@end

@interface WTPlainTextBillboardDetailHeaderView : UIView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *contentLabel;

+ (WTPlainTextBillboardDetailHeaderView *)createDetailHeaderView;

- (void)configureViewWithBillboardPost:(BillboardPost *)post;

@end
