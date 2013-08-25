//
//  WEColloectionViewController.h
//  WeCampus
//
//  Created by Song on 13-8-25.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WEColloectionViewController;

@protocol WEColloectionViewControllerDelegate <NSObject>

- (void)WEColloectionViewController:(WEColloectionViewController*)vc didSelect:(id)obj;

@end

@interface WEColloectionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,assign) id<WEColloectionViewControllerDelegate> delegate;

- (void)setCellClass:(Class)cellClass;

- (void)setData:(NSArray*)arr;

- (NSArray*)selected;


- (void)unselectAll;
@end
