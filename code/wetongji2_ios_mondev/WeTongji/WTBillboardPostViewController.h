//
//  WTBillboardPostViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-17.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WTBillboardPostViewControllerTypePlainText,
    WTBillboardPostViewControllerTypeImage,
} WTBillboardPostViewControllerType;

@interface WTBillboardPostViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *titleTextField;
@property (nonatomic, weak) IBOutlet UITextView *contentTextView;
@property (nonatomic, weak) IBOutlet UIImageView *postImageView;

- (void)configureNavigationBar;

+ (WTBillboardPostViewController *)createPostViewControllerWithType:(WTBillboardPostViewControllerType)type;

- (void)show;

@end
