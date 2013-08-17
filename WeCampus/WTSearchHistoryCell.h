//
//  WTSearchHistoryCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-12.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTSearchHistoryCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIImageView *searchIconImageView;
@property (nonatomic, weak) IBOutlet UILabel *searchKeywordLabel;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                     searchKeyword:(NSString *)keyword
                    searchCategory:(NSInteger)category;

@end
