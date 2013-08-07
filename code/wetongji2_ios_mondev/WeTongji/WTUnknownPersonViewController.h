//
//  WTUnknownPersonViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>

@class User;

@interface WTUnknownPersonViewController : ABUnknownPersonViewController

+ (void)showWithUser:(User *)user avatar:(UIImage *)avatar;

@end
