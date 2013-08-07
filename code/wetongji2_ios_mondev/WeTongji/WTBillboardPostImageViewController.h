//
//  WTBillboardPostImageViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-17.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTBillboardPostViewController.h"

@interface WTBillboardPostImageViewController : WTBillboardPostViewController

@property (nonatomic, weak) IBOutlet UIView *titleBgView;
@property (nonatomic, weak) IBOutlet UIImageView *titleBgImageView;

- (IBAction)didClickPickImageFromCameraButton:(UIButton *)sender;

- (IBAction)didClickPickImageFromLibraryButton:(UIButton *)sender;

@end
