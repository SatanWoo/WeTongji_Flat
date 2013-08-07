//
//  WTConfigLoader.h
//  WeTongji
//
//  Created by 王 紫川 on 13-2-7.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTableViewType                      @"TableViewType"
#define kTableViewContent                   @"TableViewContent"
#define kRequireOSVersion                   @"RequireOSVersion"

#define kCellTitle                          @"CellTitle"
#define kCellThumbnail                      @"CellThumbnail"
#define kCellAccessoryType                  @"CellAccessoryType"
#define kButtonTitle                        @"ButtonTitle"
#define kButtonTarget                       @"ButtonTarget"
#define kButtonStyle                        @"ButtonStyle"
#define kButtonStyleFocus                   @"ButtonStyleFocus"

#define kCellAccessoryTypeNone              @"CellAccessoryTypeNone"
#define kCellAccessoryTypeSwitch            @"CellAccessoryTypeSwitch"
#define kCellAccessoryTypeDisclosure        @"CellAccessoryTypeDisclosure"
#define kCellAccessoryTypeCheckmark         @"CellAccessoryTypeCheckmark"

#define kTableViewTypePlain                 @"TableViewTypePlain"
#define kTableViewTypeGroup                 @"TableViewTypeGroup"
#define kTableViewTypeSeparator             @"TableViewTypeSeparator"
#define kTableViewTypeButton                @"TableViewTypeButton"
#define kTableViewTypeTextField             @"TableViewTypeTextField"

#define kTableViewSectionHeader             @"TableViewSectionHeader"
#define kTableViewSupportsMultiSelection    @"TableViewSupportsMultiSelection"
#define kUserDefaultKey                     @"UserDefaultKey"

#define kDistrictIndexArray                 @"DistrictIndexArray"

#define kWTActivityConfig                   @"WTActivitySettingConfig"
#define kWTNewsConfig                       @"WTNewsSettingConfig"
#define kWTMeConfig                         @"WTMeSettingConfig"
#define KWTDistrictBuildingMap              @"WTDistrictBuildingMap"

@interface WTConfigLoader : NSObject {
    NSMutableDictionary *_configDictionary;
}

+ (WTConfigLoader *)sharedLoader;

- (id)loadConfig:(NSString *)configKey;

@end
