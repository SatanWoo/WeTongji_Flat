//
//  WESchoolEventHeadLineView.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-11.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity+Addition.h"

@protocol WESchoolEventHeadLineViewDelegate <NSObject>

- (void)didClickShowCategoryButtonWithModel:(Activity *)act;

@end

@interface WESchoolEventHeadLineView : UIView
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) id<WESchoolEventHeadLineViewDelegate> delegate;

+ (WESchoolEventHeadLineView *)createWESchoolEventHeadLineViewWithModel:(Activity *)act;
- (IBAction)didClickShowCategory:(id)sender;

@end
