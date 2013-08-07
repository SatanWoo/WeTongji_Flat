//
//  WTUnknownPersonViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTUnknownPersonViewController.h"
#import "WTResourceFactory.h"
#import "User+Addition.h"
#import "UIApplication+WTAddition.h"
#import "WTNavigationViewController.h"

@interface WTUnknownPersonViewController () <ABUnknownPersonViewControllerDelegate>

@end

@implementation WTUnknownPersonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self configureNavigationBar];
}

+ (void)showWithUser:(User *)user avatar:(UIImage *)avatar {
    WTUnknownPersonViewController *vc = [[WTUnknownPersonViewController alloc] init];
    
    ABRecordRef person = ABPersonCreate();
    ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFTypeRef)(user.name), NULL);
    
    if (user.emailAddress) {
        ABMutableMultiValueRef emailAddress = ABMultiValueCreateMutable(kABStringPropertyType);
        ABMultiValueAddValueAndLabel(emailAddress, (__bridge CFTypeRef)(user.emailAddress), kABWorkLabel, NULL);
        ABRecordSetValue(person, kABPersonEmailProperty, emailAddress, NULL);
        CFRelease(emailAddress);
    }
    
    if (avatar) {
        ABPersonSetImageData (person, (__bridge CFDataRef)UIImagePNGRepresentation(avatar), NULL);
    }
    
    if (user.phoneNumber) {
        ABMutableMultiValueRef phone = ABMultiValueCreateMutable(kABStringPropertyType);
        ABMultiValueAddValueAndLabel(phone, (__bridge CFTypeRef)(user.phoneNumber), kABPersonPhoneMainLabel, NULL);
        ABRecordSetValue(person, kABPersonPhoneProperty, phone, NULL);
        CFRelease(phone);
    }
    
    if (user.department) {
        ABRecordSetValue(person, kABPersonDepartmentProperty, (__bridge CFTypeRef)(user.department), NULL);
    }
    
    if (user.birthday) {
        ABRecordSetValue(person, kABPersonBirthdayProperty, (__bridge CFDateRef)user.birthday, NULL);
    }
    
    vc.alternateName = user.name;
    vc.allowsAddingToAddressBook = YES;
    vc.displayedPerson = person;
    vc.unknownPersonViewDelegate = vc;
    
    WTNavigationViewController *nav = [[WTNavigationViewController alloc] initWithRootViewController:vc];
    [[UIApplication sharedApplication].rootTabBarController presentViewController:nav animated:YES completion:nil];
    
    CFRelease(person);
}

- (void)configureNavigationBar {
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Cancel", nil) target:self action:@selector(didClickCancelButton:)];
    
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Create Contact", nil)];
}

- (void)didClickCancelButton:(UIButton *)sender {
    [[UIApplication sharedApplication].rootTabBarController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ABUnknownPersonViewControllerDelegate

- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownCardViewController didResolveToPerson:(ABRecordRef)person {
    [[UIApplication sharedApplication].rootTabBarController dismissViewControllerAnimated:YES completion:nil];
}

@end
