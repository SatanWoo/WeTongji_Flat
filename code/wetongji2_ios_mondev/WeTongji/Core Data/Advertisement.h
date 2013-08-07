//
//  Advertisement.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object.h"
@interface Advertisement : Object

@property (nonatomic, retain) NSString * bgColorHex;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * publisher;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * website;

@end
