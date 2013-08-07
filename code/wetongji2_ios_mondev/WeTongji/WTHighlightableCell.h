//
//  WTHighlightableCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTHighlightableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *topSeperatorImageView;
@property (nonatomic, weak) IBOutlet UIView *highlightBgView;
@property (nonatomic, weak) IBOutlet UIImageView *disclosureImageView;
@property (nonatomic, weak) IBOutlet UIView *containerView;

- (void)configureCellWithHighlightStatus:(BOOL)highlighted;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath;

@end
