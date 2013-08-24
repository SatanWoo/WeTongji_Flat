//
//  WEAboutViewController.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-18.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEContentViewController.h"

@interface WEAboutViewController : WEContentViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;

- (IBAction)didClickUserProtocol:(id)sender;
- (IBAction)didClickShare:(id)sender;
- (IBAction)didClickSuggest:(id)sender;

@end
