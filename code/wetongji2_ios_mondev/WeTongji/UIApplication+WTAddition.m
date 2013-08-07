//
//  UIApplication+WTAddition.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "UIApplication+WTAddition.h"
#import "WTAppDelegate.h"
#import "Event+Addition.h"
#import "Activity+Addition.h"
#import "Course+Addition.h"
#import "WTActivityDetailViewController.h"
#import "WTCourseInstanceDetailViewController.h"

static UIViewController *staticKeyWindowViewController;
static UIView           *staticKeyWindowBgView;
@implementation UIApplication (WTAddition)

+ (void)showTopCorner {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIImageView *topLeftCornerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTCornerTopLeft"]];
    UIImageView *topRightCornerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTCornerTopRight"]];
    [topLeftCornerImageView resetOrigin:CGPointMake(0, 20)];
    [topRightCornerImageView resetOrigin:CGPointMake(screenSize.width - topRightCornerImageView.frame.size.width, 20)];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:topLeftCornerImageView];
    [keyWindow addSubview:topRightCornerImageView];
}

- (WTRootTabBarController *)rootTabBarController {
    WTAppDelegate *appDelegate = (WTAppDelegate *)[[UIApplication sharedApplication] delegate];
    return (WTRootTabBarController *)appDelegate.window.rootViewController;
}

- (WTHomeViewController *)homeViewController {
    WTRootTabBarController *rootTabBarViewController = [UIApplication sharedApplication].rootTabBarController;
    UINavigationController *homeNavigationController = rootTabBarViewController.viewControllers[WTRootTabBarViewControllerHome];
    return homeNavigationController.viewControllers[0];
}

- (WTNowViewController *)nowViewController {
    WTRootTabBarController *rootTabBarViewController = [UIApplication sharedApplication].rootTabBarController;
    UINavigationController *nowNavigationController = rootTabBarViewController.viewControllers[WTRootTabBarViewControllerNow];
    return nowNavigationController.viewControllers[0];
}

- (WTBillboardViewController *)billboardViewController {
    WTRootTabBarController *rootTabBarViewController = [UIApplication sharedApplication].rootTabBarController;
    UINavigationController *billboardNavigationController = rootTabBarViewController.viewControllers[WTRootTabBarViewControllerBillboard];
    return billboardNavigationController.viewControllers[0];
}

- (WTSearchViewController *)searchViewController {
    WTRootTabBarController *rootTabBarViewController = [UIApplication sharedApplication].rootTabBarController;
    UINavigationController *searchNavigationController = rootTabBarViewController.viewControllers[WTRootTabBarViewControllerSearch];
    return searchNavigationController.viewControllers[0];
}

- (WTMeViewController *)meViewController {
    WTRootTabBarController *rootTabBarViewController = [UIApplication sharedApplication].rootTabBarController;
    UINavigationController *meNavigationController = rootTabBarViewController.viewControllers[WTRootTabBarViewControllerMe];
    return meNavigationController.viewControllers[0];
}

#pragma mark - Key window view controller

+ (void)presentKeyWindowViewController:(UIViewController *)vc animated:(BOOL)animated {
    if (staticKeyWindowViewController)
        return;
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    staticKeyWindowViewController = vc;
	staticKeyWindowBgView = [[UIView alloc] initWithFrame:screenBounds];
    vc.view.frame = screenBounds;
	staticKeyWindowBgView.backgroundColor = [UIColor blackColor];
        
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
	[keyWindow addSubview:staticKeyWindowBgView];
	[keyWindow addSubview:vc.view];
    
    if(animated) {
        [vc.view resetOriginY:screenBounds.size.height];
        staticKeyWindowBgView.alpha = 0;
        [UIView animateWithDuration:0.25f animations:^{
            staticKeyWindowBgView.alpha = 1.0f;
            [vc.view resetOriginY:0];
        }];
    } else {
        staticKeyWindowBgView.alpha = 0;
    }
}

+ (void)dismissKeyWindowViewControllerAnimated:(BOOL)animated {
    if (animated) {
        staticKeyWindowBgView.alpha = 1.0f;
        [UIView animateWithDuration:0.25f animations:^{
            staticKeyWindowBgView.alpha = 0;
            [staticKeyWindowViewController.view resetOriginY:staticKeyWindowViewController.view.frame.size.height];
        } completion:^(BOOL finished) {
            [UIApplication clearKeyWindowViewController];
        }];
    } else {
        [UIApplication clearKeyWindowViewController];
    }
}

+ (void)clearKeyWindowViewController {
    [staticKeyWindowBgView removeFromSuperview];
    staticKeyWindowBgView = nil;
    [staticKeyWindowViewController.view removeFromSuperview];
    staticKeyWindowViewController = nil;
}

#define kLocalNotificationEventType         @"LocalNotificationEventType"
#define kLocalNotificationEventID           @"LocalNotificationEventID"
#define kLocalNotificationEventBeginTime    @"LocalNotificationEventBeginTime"

- (void)removeEventAlertNotificationWithEvent:(Event *)event {
    NSArray *scheduledNotifications = [self scheduledLocalNotifications];
    for (UILocalNotification *notification in scheduledNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if ([userInfo[kLocalNotificationEventType] isEqualToString:event.objectClass]
            && [userInfo[kLocalNotificationEventID] isEqualToString:event.identifier]) {
            [self cancelLocalNotification:notification];
            return;
        }
    }
}

- (void)addEventAlertNotificationWithEvent:(Event *)event {
    
    if (!event)
        return;
    
    if (![[NSUserDefaults standardUserDefaults] scheduleNotificationEnabled]) {
        return;
    }
    
    // Check whether event is overdue
    if ([event.beginTime compare:[NSDate date]] == NSOrderedAscending) {
        return;
    }
    
    // Check whether notification exists
    NSArray *scheduledNotifications = [self scheduledLocalNotifications];
    for (UILocalNotification *notification in scheduledNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if ([userInfo[kLocalNotificationEventType] isEqualToString:event.objectClass]
            && [userInfo[kLocalNotificationEventID] isEqualToString:event.identifier] && [userInfo[kLocalNotificationEventBeginTime] doubleValue] == [event.beginTime timeIntervalSince1970]) {
            return;
        }
    }
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
        
    localNotif.fireDate = [event.beginTime dateByAddingTimeInterval:-60 * 30];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"zh-Hans"]) {
        localNotif.alertBody = [NSString stringWithFormat:@"%@ 将在30分钟内开始。", event.what];
    } else if ([language isEqualToString:@"de"]) {
      localNotif.alertBody = [NSString stringWithFormat:@"%@ wird in dreißig Minuten zu starten.", event.what];
    } else {
        localNotif.alertBody = [NSString stringWithFormat:@"%@ will start in thirty minutes.", event.what];
    }
    
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    localNotif.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:event.objectClass, kLocalNotificationEventType, event.identifier, kLocalNotificationEventID, [NSString stringWithFormat:@"%f", [event.beginTime timeIntervalSince1970]], kLocalNotificationEventBeginTime, nil];
    WTLOG(@"add localNotif userInfo%@", localNotif.userInfo);
    
    [self scheduleLocalNotification:localNotif];
}

- (void)handleLocalNotification:(UILocalNotification *)localNotif {
    if (localNotif) {
        
        [self cancelLocalNotification:localNotif];
        
        NSString *eventType = localNotif.userInfo[kLocalNotificationEventType];
        NSString *eventID = localNotif.userInfo[kLocalNotificationEventID];
        NSDate *eventBeginTime = [NSDate dateWithTimeIntervalSince1970:[localNotif.userInfo[kLocalNotificationEventBeginTime] doubleValue]];
        
        WTLOG(@"receive localNotif userInfo%@", localNotif.userInfo);
        UIViewController *vc = nil;
        if ([eventType isEqualToString:NSStringFromClass([Activity class])]) {
            Activity *activity = [Activity activityWithID:eventID];
            vc = [WTActivityDetailViewController createDetailViewControllerWithActivity:activity backBarButtonText:nil];
            
        } else if ([eventType isEqualToString:NSStringFromClass([CourseInstance class])]) {
            CourseInstance *courseInstance = [CourseInstance courseInstanceWithCourseID:eventID beginTime:eventBeginTime];
            vc = [WTCourseInstanceDetailViewController createDetailViewControllerWithCourseInstance:courseInstance backBarButtonText:nil];
        }
        
        if (vc) {
            [self.rootTabBarController setTabBarButtonSelected:WTRootTabBarViewControllerHome];
            self.rootTabBarController.selectedIndex = WTRootTabBarViewControllerHome;
            UINavigationController *nav = self.rootTabBarController.viewControllers[WTRootTabBarViewControllerHome];
            [nav popToRootViewControllerAnimated:NO];
            [nav pushViewController:vc animated:NO];
        }
    }
}

@end
