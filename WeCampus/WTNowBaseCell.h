//
//  WTNowBaseCell.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-1-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OHAttributedLabel;

typedef enum {
    WTNowBaseCellTypePast,
    WTNowBaseCellTypeNormal,
    WTNowBaseCellTypeNow,
} WTNowBaseCellType;

@class Event;

@interface WTNowBaseCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *startTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *endTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *eventNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *whereLabel;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIButton *bgButton;

- (IBAction)didClickBgButton:(UIButton *)sender;

- (void)updateCellStatus:(WTNowBaseCellType)type;

- (void)setCellPast:(BOOL)past;

- (void)configureCellWithEvent:(Event *)event;

@end
