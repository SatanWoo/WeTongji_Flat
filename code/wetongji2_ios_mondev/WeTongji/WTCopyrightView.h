//
//  WTCopyrightView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTCopyrightView : UIView

@property (nonatomic, weak) IBOutlet UILabel *versionDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *copyrightDisplayLabel;

+ (WTCopyrightView *)createView;

@end
