//
//  WTConfigLoader.m
//  WeTongji
//
//  Created by 王 紫川 on 13-2-7.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTConfigLoader.h"

@implementation WTConfigLoader

- (id)init {
    self = [super init];
    if (self) {
        _configDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)loadConfig:(NSString *)configKey {
    if (!_configDictionary[configKey]) {
        [self readPlist:configKey];
    }
    return _configDictionary[configKey];
}

+ (WTConfigLoader *)sharedLoader {
    static WTConfigLoader *loader = nil;
    static dispatch_once_t WTConfigLoaderPredicate;
    dispatch_once(&WTConfigLoaderPredicate, ^{
        loader = [[WTConfigLoader alloc] init];
    });
    
    return loader;
}

- (void)readPlist:(NSString *)configKey {
    NSString *configFilePath = [[NSBundle mainBundle] pathForResource:configKey ofType:@"plist"];
    id result = nil;
    if ([configKey isEqualToString:KWTDistrictBuildingMap]) {
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:configFilePath];
        result = dict;
    } else {
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:configFilePath];
        result = array;
    }
    _configDictionary[configKey] = result;
}

@end
