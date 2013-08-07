//
//  WTNowBaseCell.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-1-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowBaseCell.h"
#import "OHAttributedLabel.h"
#import "Event.h"
#import "UIApplication+WTAddition.h"
#import "WTNowViewController.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+WTAddition.h"

@interface WTNowBaseCell ()

@property (nonatomic, weak) Event *event;

@end

@implementation WTNowBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib {
    self.nowDisplayLabel.text = NSLocalizedString(@"Ongoing", nil);
    CGFloat nowDisplayLabelHeight = self.nowDisplayLabel.frame.size.height;
    [self.nowDisplayLabel sizeToFit];
    [self.nowDisplayLabel resetHeight:nowDisplayLabelHeight];
    
    self.friendsCountLabel.automaticallyAddLinksForType = 0;
}

- (void)configureCellWithEvent:(Event *)event {
    self.event = event;
    
    self.friendsCountLabel.attributedText = [NSAttributedString friendCountStringConvertFromCountNumber:self.event.friendsCount font:self.friendsCountLabel.font textColor:self.friendsCountLabel.textColor];
}

#pragma mark - UI methods

- (void)showNowView {
    self.nowView.hidden = NO;
    CGPoint nowDisplayLabelOrigin = [self.nowDisplayLabel convertPoint:self.nowDisplayLabel.frame.origin toView:self.nowView];
    [self.whenLabel resetOriginX:nowDisplayLabelOrigin.x + self.nowDisplayLabel.frame.size.width + 20];
}

- (void)hideNowView {
    self.nowView.hidden = YES;
    [self.whenLabel resetOriginX:self.nowView.frame.origin.x + 2];
}

- (void)setCellPast:(BOOL)past {
    if (past) {
        [self.bgButton setBackgroundImage:[UIImage imageNamed:@"WTRoundCornerPanelCuppedBg"] forState:UIControlStateNormal];
        [self.bgButton setBackgroundImage:[UIImage imageNamed:@"WTRoundCornerPanelCuppedBg"] forState:UIControlStateHighlighted];
        self.whenLabel.highlighted = YES;
        self.whenLabel.shadowOffset = CGSizeZero;
        self.whereLabel.highlighted = YES;
        self.whereLabel.shadowOffset = CGSizeZero;
    } else {
        [self.bgButton setBackgroundImage:[UIImage imageNamed:@"WTRoundCornerPanelBg"] forState:UIControlStateNormal];
        [self.bgButton setBackgroundImage:[UIImage imageNamed:@"WTRoundCornerPanelHighlightBg"] forState:UIControlStateHighlighted];
        self.whenLabel.highlighted = NO;
        self.whenLabel.shadowOffset = CGSizeMake(0, 1);
        self.whereLabel.highlighted = NO;
        self.whereLabel.shadowOffset = CGSizeMake(0, 1);
    }
}

- (void)updateCellStatus:(WTNowBaseCellType)type {
    if (type == WTNowBaseCellTypePast) {
        [self setCellPast:YES];
    } else {
        [self setCellPast:NO];
    }
        
    if (type == WTNowBaseCellTypeNow){
        [self showNowView];
        self.ringImageView.hidden = NO;
    } else {
        [self hideNowView];
        self.ringImageView.hidden = YES;
    }
}

#pragma mark - Actions

- (IBAction)didClickBgButton:(UIButton *)sender {
    WTNowViewController *nowViewControler = [UIApplication sharedApplication].nowViewController;
    [nowViewControler showNowItemDetailViewWithEvent:self.event];
}

@end
