//
//  WESchoolEventHeadLineView.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-11.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity+Addition.h"

typedef enum {
    WESchoolEventHeadLineActivity = 0,
    WESchoolEventHeadLineLecture = 1,
    WESchoolEventHeadLineGame = 2,
    WESchoolEventHeadLineJob = 3
}WESchoolEventHeadLineType;

@interface WESchoolEventHeadLineView : UIView
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

+ (WESchoolEventHeadLineView *)createWESchoolEventHeadLineViewWithModel:(Activity *)act;

@end
