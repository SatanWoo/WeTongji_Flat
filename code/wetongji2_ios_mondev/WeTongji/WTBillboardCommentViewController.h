//
//  WTBillboardCommentViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-24.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCoreDataTableViewController.h"

@class BillboardPost;
@class Comment;

@protocol WTBillboardCommentViewControllerDelegate;

@interface WTBillboardCommentViewController : WTCoreDataTableViewController

@property (nonatomic, weak) id<WTBillboardCommentViewControllerDelegate> delegate;

+ (WTBillboardCommentViewController *)createCommentViewControllerWithBillboardPost:(BillboardPost *)post
                                                                          delegate:(id<WTBillboardCommentViewControllerDelegate>)delegate;

@end

@protocol WTBillboardCommentViewControllerDelegate <NSObject>

- (UIView *)commentViewControllerTableViewHeaderView;

- (void)didSelectComment:(Comment *)comment;

@end