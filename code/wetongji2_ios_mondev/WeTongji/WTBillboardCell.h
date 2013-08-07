//
//  WTBillboardCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTBillboardCell : UITableViewCell

- (void)configureCellWithBillboardPosts:(NSArray *)posts
                              indexPath:(NSIndexPath *)indexPath;

@end