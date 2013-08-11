//
//  LikeableObject+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "LikeableObject+Addition.h"
#import "WTCoreDataManager.h"
#import "NSNotificationCenter+WTAddition.h"
#import "BillboardPost.h"
#import "Activity.h"
#import "News.h"
#import "Star.h"
#import "Organization.h"

@implementation LikeableObject (Addition)

- (void)configureLikeInfo:(NSDictionary *)dict {
    self.likeCount = @([([NSString stringWithFormat:@"%@", dict[@"Like"]]) integerValue]);
    if (dict[@"CanLike"])
        self.likedByCurrentUser = ![[NSString stringWithFormat:@"%@", dict[@"CanLike"]] boolValue];
}

#pragma mark - Properties

- (BOOL)likedByCurrentUser {
    return [[WTCoreDataManager sharedManager].currentUser.likedObjects containsObject:self];
}

- (void)setLikedByCurrentUser:(BOOL)likedByCurrentUser {
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    if (!currentUser)
        return;
    if (likedByCurrentUser) {
        if ([currentUser.likedObjects containsObject:self])
            return;
        WTLOG(@"add like object:%@, model:%@", self.identifier, self.objectClass);
        [currentUser addLikedObjectsObject:self];
    } else {
        if (![currentUser.likedObjects containsObject:self])
            return;
        WTLOG(@"remove like object:%@, model:%@", self.identifier, self.objectClass);
        [currentUser removeLikedObjectsObject:self];
    }
}

@end
