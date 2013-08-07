//
//  WTInnerSettingViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-2-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTInnerSettingViewController.h"
#import "WTConfigLoader.h"
#import "WTSwitch.h"
#import "WTResourceFactory.h"
#import "WTWaterflowDecorator.h"
#import "NSNotificationCenter+WTAddition.h"

@interface WTInnerSettingViewController () <WTWaterflowDecoratorDataSource>

@property (nonatomic, strong) NSArray *settingConfig;
@property (nonatomic, strong) WTWaterflowDecorator *waterflowDecorator;

@property (nonatomic, assign) BOOL dirty;

@property (nonatomic, strong) NSMutableArray *innerSettingItems;

@end

@implementation WTInnerSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configureScrollView];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.scrollView resetHeight:self.view.frame.size.height - 41.0f];
    [NSNotificationCenter registerInnerSettingItemDidModifyNotificationWithSelector:@selector(settingItemDidModify) target:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillLayoutSubviews {
    [self.waterflowDecorator adjustWaterflowView];
}

- (void)viewDidLayoutSubviews {
    [self.waterflowDecorator adjustWaterflowView];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.waterflowDecorator adjustWaterflowView];
}

#pragma mark - Methods to overwrite

- (NSArray *)loadSettingConfig {
    return nil;
}

#pragma mark - Properties

- (WTWaterflowDecorator *)waterflowDecorator {
    if (!_waterflowDecorator) {
        _waterflowDecorator = [WTWaterflowDecorator createDecoratorWithDataSource:self];
    }
    return _waterflowDecorator;
}

- (NSMutableArray *)innerSettingItems {
    if (!_innerSettingItems) {
        _innerSettingItems = [NSMutableArray array];
    }
    return _innerSettingItems;
}

- (NSArray *)settingConfig {
    if (_settingConfig == nil) {
        _settingConfig = [self loadSettingConfig];
    }
    return _settingConfig;
}

#pragma mark - UI methods

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    CGFloat originY = 0;
    for (NSDictionary *dict in self.settingConfig) {
        
        NSNumber *requireOSVersion = dict[kRequireOSVersion];
        if ([UIDevice currentDevice].systemVersion.floatValue < requireOSVersion.floatValue) {
            continue;
        }
        
        NSString *tableViewType = dict[kTableViewType];
        if ([tableViewType isEqualToString:kTableViewTypePlain]) {
            NSArray *contentArray = dict[kTableViewContent];
            for (NSDictionary *cellDict in contentArray) {
                WTSettingPlainCell *plainCell = [WTSettingPlainCell createPlainCell:cellDict];
                [plainCell resetOriginY:originY];
                originY += plainCell.frame.size.height;
                [self.scrollView addSubview:plainCell];
                [self.innerSettingItems addObject:plainCell];
            }
        } else if ([tableViewType isEqualToString:kTableViewTypeGroup]) {
            WTSettingGroupTableView *tableView = [WTSettingGroupTableView createGroupTableView:dict];
            [tableView resetOriginY:originY];
            originY += tableView.frame.size.height;
            [self.scrollView addSubview:tableView];
            [self.innerSettingItems addObject:tableView];
            
        } else if ([tableViewType isEqualToString:kTableViewTypeSeparator]) {
            UIImageView *separatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTInnerModalSeparator"]];
            originY += self.scrollView.contentInset.top;
            [separatorImageView resetCenterY:originY];
            originY += self.scrollView.contentInset.top;
            [self.scrollView addSubview:separatorImageView];
        } else if ([tableViewType isEqualToString:kTableViewTypeButton]) {
            NSArray *contentArray = dict[kTableViewContent];
            for (NSDictionary *cellDict in contentArray) {
                WTSettingButtonCell *buttonCell = [WTSettingButtonCell createButtonCell:cellDict target:self];
                [buttonCell resetOriginY:originY];
                originY += buttonCell.frame.size.height;
                [self.scrollView addSubview:buttonCell];
                [self.innerSettingItems addObject:buttonCell];
            }
        } else if ([tableViewType isEqualToString:kTableViewTypeTextField]) {
            NSArray *contentArray = dict[kTableViewContent];
            for (NSDictionary *cellDict in contentArray) {
                WTSettingTextFieldCell *textFieldCell = [WTSettingTextFieldCell createTextFieldCell:cellDict];
                [textFieldCell resetOriginY:originY];
                originY += textFieldCell.frame.size.height;
                [self.scrollView addSubview:textFieldCell];
                [self.innerSettingItems addObject:textFieldCell];
            }
        }
    }
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, originY)];
}

#pragma mark - WTWaterflowDecoratorDataSource

- (UIScrollView *)waterflowScrollView {
    return self.scrollView;
}

- (NSString *)waterflowUnitImageName {
    return @"WTInnerModalViewBg";
}

#pragma mark - Notification handler

- (void)settingItemDidModify {
    for (id<WTInnerSettingItem> item in self.innerSettingItems) {
        if (![item respondsToSelector:@selector(isDirty)])
            continue;
        if ([item isDirty]) {
            self.dirty = YES;
            return;
        }
    }
    self.dirty = NO;
}

#pragma mark - WTRootNavigationControllerDelegate

- (void)didHideInnderModalViewController {
    [self.delegate innerSettingViewController:self didFinishSetting:self.dirty];
}

@end

@interface WTSettingPlainCell ()

@property (nonatomic, copy) NSString *userDefaultKey;
@property (nonatomic, assign) BOOL dirty;

@end

@implementation WTSettingPlainCell

+ (WTSettingPlainCell *)createPlainCell:(NSDictionary *)cellInfo {
    WTSettingPlainCell *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTSettingCells" owner:self options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTSettingPlainCell class]]) {
            result = (WTSettingPlainCell *)view;
            break;
        }
    }
    NSString *cellTitle = NSLocalizedString(cellInfo[kCellTitle], nil);
    NSString *cellAccessoryType = cellInfo[kCellAccessoryType];
    NSString *cellThumbnail = cellInfo[kCellThumbnail];
    result.userDefaultKey = cellInfo[kUserDefaultKey];
    
    result.titleLabel.text = cellTitle;
    if ([cellAccessoryType isEqualToString:kCellAccessoryTypeSwitch]) {
        [result createSwitch];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        BOOL value = [userDefault boolForKey:result.userDefaultKey];
        result.selectSwitch.on = value;
    }
    
    if (cellThumbnail) {
        
    }
    
    return result;
}

- (void)createSwitch {
    self.selectSwitch = [WTSwitch createSwitchWithDelegate:self];
    [self.selectSwitch resetCenterY:self.frame.size.height / 2];
    [self.selectSwitch resetOriginX:self.frame.size.width - self.selectSwitch.frame.size.width - 12.0f];
    [self addSubview:self.selectSwitch];
}

#pragma mark - WTInnerSettingItem

- (BOOL)isDirty {
    return self.dirty;
}

#pragma mark - WTSwitchDelegate

- (void)switchDidChange:(WTSwitch *)sender {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:self.userDefaultKey] != self.selectSwitch.isOn) {
        
        [userDefault setBool:self.selectSwitch.isOn forKey:self.userDefaultKey];
        [userDefault synchronize];
        
        self.dirty = !self.dirty;
        [NSNotificationCenter postInnerSettingItemDidModifyNotification];
    }
}

@end

@interface WTSettingGroupTableView ()

@property (nonatomic, strong) NSMutableArray *cellInfoArray;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, assign) BOOL supportMultiSelection;
@property (nonatomic, copy) NSString *userDefaultKey;

@end

@implementation WTSettingGroupTableView

+ (WTSettingGroupTableView *)createGroupTableView:(NSDictionary *)tableViewInfo {
    WTSettingGroupTableView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTSettingCells" owner:self options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTSettingGroupTableView class]]) {
            result = (WTSettingGroupTableView *)view;
            break;
        }
    }
    
    NSString *headerTitle = NSLocalizedString(tableViewInfo[kTableViewSectionHeader], nil);
    result.headerLabel.text = headerTitle;
    
    result.bgImageView.image = [result.bgImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
    result.supportMultiSelection = [tableViewInfo[kTableViewSupportsMultiSelection] boolValue];
    result.userDefaultKey = tableViewInfo[kUserDefaultKey];
    
    NSArray *contentArray = tableViewInfo[kTableViewContent];
    
    for (NSDictionary *cellDict in contentArray) {
        [result addCell:cellDict];
    }
    
    return result;
}

- (NSMutableArray *)cellArray {
    if (_cellArray == nil) {
        _cellArray = [NSMutableArray array];
    }
    return _cellArray;
}

- (NSMutableArray *)cellInfoArray {
    if (_cellInfoArray == nil) {
        _cellInfoArray = [NSMutableArray array];
    }
    return _cellInfoArray;
}

- (void)addCell:(NSDictionary *)cellInfo {
    NSString *cellTitle = NSLocalizedString(cellInfo[kCellTitle], nil);
    //NSString *cellAccessoryType = cellInfo[kCellAccessoryType];
    NSString *cellThumbnail = cellInfo[kCellThumbnail];
    
    WTSettingGroupCell *cell = [WTSettingGroupCell createGroupCell];
    
    if (cellThumbnail) {
        cellTitle = [NSString stringWithFormat:@"      %@", cellTitle];
        cell.thumbnailImageView.image = [UIImage imageNamed:cellThumbnail];
    }
    
    [cell.cellButton setTitle:cellTitle forState:UIControlStateNormal];
    [cell.cellButton addTarget:self action:@selector(didClickCellButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.cellInfoArray addObject:cellInfo];
    [self.cellArray addObject:cell];
    
    [self.cellContainerView addSubview:cell];
    
    [self configureTableView];
    
    NSUInteger cellIndex = cell.cellButton.tag;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger value = [userDefault integerForKey:self.userDefaultKey];
    NSInteger itemValue = 1 << cellIndex;
    if (self.supportMultiSelection) {
        cell.checkmarkImageView.hidden = ((value & itemValue) == 0);
    } else {
        cell.checkmarkImageView.hidden = !(value == itemValue);
    }
}

- (void)configureTableView {
    [self resetHeight:44.0f * self.cellInfoArray.count + (self.frame.size.height - self.cellContainerView.frame.size.height)];
    
    for (int index = 0; index < self.cellArray.count; index++) {
        WTSettingGroupCell *cell = self.cellArray[index];
        cell.separatorImageView.hidden = NO;
        [cell resetOriginY:index * 44.0f];
        cell.cellButton.tag = index;
        
    }
    WTSettingGroupCell *lastCell = self.cellArray.lastObject;
    lastCell.separatorImageView.hidden = YES;
}

#pragma mark - WTInnerSettingItem

- (BOOL)isDirty {
    for (WTSettingGroupCell *cell in self.cellArray) {
        if ([cell isDirty])
            return YES;
    }
    return NO;
}

#pragma mark - Actions

- (void)didClickCellButton:(UIButton *)sender {
    NSUInteger cellIndex = sender.tag;
    //NSDictionary *cellInfo = self.cellInfoArray[cellIndex];
    
    if (self.supportMultiSelection) {
        WTSettingGroupCell *selectCell = self.cellArray[cellIndex];
        selectCell.checkmarkImageView.hidden = !selectCell.checkmarkImageView.hidden;
        selectCell.dirty = !selectCell.dirty;
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSInteger result = [userDefault integerForKey:self.userDefaultKey];
        // Convention
        NSInteger itemValue = 1 << cellIndex;
        if (selectCell.checkmarkImageView.hidden)
            result &=  ~itemValue;
        else
            result |= itemValue;
        [userDefault setInteger:result forKey:self.userDefaultKey];
        [userDefault synchronize];
        NSLog(@"%d, %d", itemValue, result);
    } else {
        for (WTSettingGroupCell *cell in self.cellArray) {
            if (!cell.checkmarkImageView.hidden) {
                cell.dirty = !cell.dirty;
                cell.checkmarkImageView.hidden = YES;
                break;
            }
        }
        WTSettingGroupCell *selectCell = self.cellArray[cellIndex];
        selectCell.checkmarkImageView.hidden = NO;
        selectCell.dirty = !selectCell.dirty;
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        // Convention
        NSInteger itemValue = 1 << cellIndex;
        [userDefault setInteger:itemValue forKey:self.userDefaultKey];
        [userDefault synchronize];
        
        NSLog(@"%d", itemValue);
    }
    [NSNotificationCenter postInnerSettingItemDidModifyNotification];
}

@end

@interface WTSettingGroupCell ()

@end

@implementation WTSettingGroupCell

+ (WTSettingGroupCell *)createGroupCell {
    WTSettingGroupCell *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTSettingCells" owner:self options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTSettingGroupCell class]]) {
            result = (WTSettingGroupCell *)view;
            break;
        }
    }
    
    return result;
}

#pragma mark - WTInnerSettingItem

- (BOOL)isDirty {
    return self.dirty;
}

@end

@implementation WTSettingButtonCell

+ (WTSettingButtonCell *)createButtonCell:(NSDictionary *)cellInfo
                                   target:(id)target {
    WTSettingButtonCell *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTSettingCells" owner:self options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTSettingButtonCell class]]) {
            result = (WTSettingButtonCell *)view;
            break;
        }
    }
    
    UIImage *buttonBgImage = nil;
    NSString *buttonStyle = cellInfo[kButtonStyle];
    if ([buttonStyle isEqualToString:kButtonStyleFocus]) {
        buttonBgImage = [UIImage imageNamed:@"WTNotificationCellFocusButton"];
        result.button.titleLabel.shadowOffset = CGSizeMake(0, 1.0f);
        [result.button setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.35f] forState:UIControlStateNormal];
        [result.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        buttonBgImage = [UIImage imageNamed:@"WTNotificationCellButton"];
    }
    
    buttonBgImage = [buttonBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(18.0f, 10.0f, 18.0f, 10.0f)];
    [result.button setBackgroundImage:buttonBgImage forState:UIControlStateNormal];
    
    NSString *buttonTitle = NSLocalizedString(cellInfo[kButtonTitle], nil);
    [result.button setTitle:buttonTitle forState:UIControlStateNormal];
    
    NSString *buttonTarget = cellInfo[kButtonTarget];
    [result.button addTarget:target action:NSSelectorFromString(buttonTarget) forControlEvents:UIControlEventTouchUpInside];
    
    return result;
}

@end

@interface WTSettingTextFieldCell ()

@property (nonatomic, copy) NSString *userDefaultKey;
@property (nonatomic, copy) NSString *originalContent;
@property (nonatomic, assign) BOOL dirty;

@end

@implementation WTSettingTextFieldCell

+ (WTSettingTextFieldCell *)createTextFieldCell:(NSDictionary *)cellInfo {
    WTSettingTextFieldCell *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTSettingCells" owner:self options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTSettingTextFieldCell class]]) {
            result = (WTSettingTextFieldCell *)view;
            break;
        }
    }
    
    result.userDefaultKey = cellInfo[kUserDefaultKey];
    NSString *title = NSLocalizedString(cellInfo[kCellTitle], nil);
    result.titleLabel.text = title;
    NSString *content = [[NSUserDefaults standardUserDefaults] stringForKey:result.userDefaultKey];
    result.textField.text = content;
    result.originalContent = content;
    
    [result.textField addTarget:result action:@selector(textFieldValueDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    return result;
}

- (void)textFieldValueDidChange:(UITextField *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:sender.text forKey:self.userDefaultKey];
    self.dirty = ![self.originalContent isEqualToString:sender.text];
}

#pragma mark - WTInnerSettingItem

- (BOOL)isDirty {
    return self.dirty;
}

@end