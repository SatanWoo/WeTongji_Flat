//
//  WTInputDormRoomNumberView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTInputDormRoomNumberView.h"

@interface WTInputDormRoomNumberView () <UITextFieldDelegate>

@end

@implementation WTInputDormRoomNumberView

+ (WTInputDormRoomNumberView *)createView {
    WTInputDormRoomNumberView *result = [[NSBundle mainBundle] loadNibNamed:@"WTInputDormRoomNumberView" owner:nil options:nil].lastObject;
    
    return result;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.roomNumberTextField.placeholder = NSLocalizedString(@"Enter Room No.", nil);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.roomNumberTextField) {
        [textField resignFirstResponder];
    }
    return NO;
}

@end
