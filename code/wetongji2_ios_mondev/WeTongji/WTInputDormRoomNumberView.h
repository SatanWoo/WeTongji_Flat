//
//  WTInputDormRoomNumberView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTInputDormRoomNumberView : UIView

@property (nonatomic, weak) IBOutlet UITextField *roomNumberTextField;

+ (WTInputDormRoomNumberView *)createView;

@end
