//
//  WTDormCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTHighlightableCell.h"

@interface WTDormCell : WTHighlightableCell

@property (nonatomic, weak) IBOutlet UILabel *buildingLabel;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                      buildingName:(NSString *)buildingName;

@end
