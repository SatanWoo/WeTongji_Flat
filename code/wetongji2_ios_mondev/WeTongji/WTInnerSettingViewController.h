//
//  WTInnerSettingViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-2-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTInnerModalViewController.h"
#import "WTSwitch.h"

@class WTInnerSettingViewController;

@protocol WTInnerSettingViewControllerDelegate <NSObject>

- (void)innerSettingViewController:(WTInnerSettingViewController *)controller
                  didFinishSetting:(BOOL)modified;

@end

@protocol WTInnerSettingItem <NSObject>

- (BOOL)isDirty;

@end

@interface WTInnerSettingViewController : WTInnerModalViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) id<WTInnerSettingViewControllerDelegate> delegate;

@property (nonatomic, readonly) NSMutableArray *innerSettingItems;

- (NSArray *)loadSettingConfig;

- (void)settingItemDidModify;

@end

@interface WTSettingPlainCell : UIView <WTSwitchDelegate, WTInnerSettingItem>

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) WTSwitch *selectSwitch;

+ (WTSettingPlainCell *)createPlainCell:(NSDictionary *)cellInfo;

@end

@interface WTSettingGroupTableView : UIView <WTInnerSettingItem>

@property (nonatomic, strong) IBOutlet UILabel *headerLabel;
@property (nonatomic, strong) IBOutlet UIView *cellContainerView;
@property (nonatomic, strong) IBOutlet UIImageView *bgImageView;

+ (WTSettingGroupTableView *)createGroupTableView:(NSDictionary *)tableViewInfo;

@end

@interface WTSettingGroupCell : UIView <WTInnerSettingItem>

@property (nonatomic, strong) IBOutlet UIImageView *checkmarkImageView;
@property (nonatomic, strong) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, strong) IBOutlet UIButton *cellButton;
@property (nonatomic, strong) IBOutlet UIImageView *separatorImageView;

@property (nonatomic, assign) BOOL dirty;

+ (WTSettingGroupCell *)createGroupCell;

@end

@interface WTSettingButtonCell : UIView

@property (nonatomic, strong) IBOutlet UIButton *button;

+ (WTSettingButtonCell *)createButtonCell:(NSDictionary *)cellInfo
                                   target:(id)target;

@end

@interface WTSettingTextFieldCell : UIView <WTInnerSettingItem>

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UITextField *textField;

+ (WTSettingTextFieldCell *)createTextFieldCell:(NSDictionary *)cellInfo;

@end
