//
//  WTCopyrightView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCopyrightView.h"

@implementation WTCopyrightView

+ (WTCopyrightView *)createView {
    return [[NSBundle mainBundle] loadNibNamed:@"WTCopyrightView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    NSString *currentBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionDisplayLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"WeTongji", nil), currentBundleVersion];
    
    self.copyrightDisplayLabel.text = NSLocalizedString(@"Copyright © 2013 Tongji University", nil);
}

@end
