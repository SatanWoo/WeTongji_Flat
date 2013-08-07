//
//  WTElectricityQueryViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTElectricityQueryViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *label;

@property (nonatomic, weak) IBOutlet UITextField *districtTextField;
@property (nonatomic, weak) IBOutlet UITextField *buildingTextField;
@property (nonatomic, weak) IBOutlet UITextField *roomTextField;

+ (void)show;

- (IBAction)didClickRefreshButton:(UIButton *)sender;

@end
