//
//  WTDebugTool.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTDebugTool : NSObject

#define WTDEBUG 1

#ifdef WTDEBUG
#define WTLOG(...) NSLog(@"WTLOG$ %@", [NSString stringWithFormat:__VA_ARGS__])
#define WTLOGERROR(...) NSLog(@"WTLOGERROR$ %@", [NSString stringWithFormat:__VA_ARGS__])

#else
#define WTLOG(...) do {} while (0)
#define WTLOGERROR(...) do {} while (0)

#endif

@end
