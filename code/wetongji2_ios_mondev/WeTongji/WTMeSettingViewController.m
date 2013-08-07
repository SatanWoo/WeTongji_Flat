//
//  WTMeSettingViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTMeSettingViewController.h"
#import "WTConfigLoader.h"
#import "WTCoreDataManager.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "UIApplication+WTAddition.h"
#import "WTMeViewController.h"
#import "WTTermOfUseViewController.h"
#import "WTLoginViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "WTTeamMemberViewController.h"
#import "WTChangePasswordViewController.h"
#import "WTSelectDormViewController.h"
#import "RDActivityViewController.h"
#import "NSUserDefaults+WTAddition.h"
#import "WTCopyrightView.h"

#define WE_TONGJI_EMAIL             @"wetongji2012@gmail.com"
#define WE_TONGJI_SINA_WEIBO_URL    @"http://www.weibo.com/wetongji"
#define WE_TONGJI_APP_STORE_URL     @"http://itunes.apple.com/cn/app/id526260090?mt=8"

@interface WTMeSettingViewController () <UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, RDActivityViewControllerDelegate, WTSelectDormViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *textFieldArray;

@property (nonatomic, weak) UITextField *dormTextField;

@end

@implementation WTMeSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"WTInnerSettingViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerTextFields];
    
    [self configureCopyrightView];
}

- (void)configureCopyrightView {
    WTCopyrightView *view = [WTCopyrightView createView];
    [view resetOriginY:self.scrollView.contentSize.height];
    [self.scrollView addSubview:view];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + view.frame.size.height);
}

- (NSMutableArray *)textFieldArray {
    if (!_textFieldArray) {
        _textFieldArray = [NSMutableArray array];
    }
    return _textFieldArray;
}

- (NSArray *)loadSettingConfig {
    return [[WTConfigLoader sharedLoader] loadConfig:kWTMeConfig];
}

- (void)registerTextFields {
    for (UIView *itemView in self.innerSettingItems) {
        if ([itemView isKindOfClass:[WTSettingTextFieldCell class]]) {
            WTSettingTextFieldCell *textFieldCell = (WTSettingTextFieldCell *)itemView;
            textFieldCell.textField.delegate = self;
            [self.textFieldArray addObject:textFieldCell.textField];
            
            if ([textFieldCell.titleLabel.text isEqualToString:NSLocalizedString(@"Dorm", nil)]) {
                self.dormTextField = textFieldCell.textField;
            }
        }
    }
}

#pragma mark - Actions 

- (void)didClickLogoutButton:(UIButton *)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                    message:NSLocalizedString(@"Are you sure you want to logout?", nil)
                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"Logout", nil), nil];
    
    [alert show];
}

- (void)didClickVisitOfficialWebsiteButton:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"http://we.tongji.edu.cn"];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)didClickShareButton:(UIButton *)sender {
    RDActivityViewController *vc = [[RDActivityViewController alloc] initWithDelegate:self];
    vc.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    [[UIApplication sharedApplication].rootTabBarController presentViewController:vc animated:YES completion:nil];
}

- (void)didClickTermOfUseButton:(UIButton *)sender {
    WTTermOfUseViewController *vc = [WTTermOfUseViewController createViewControllerWithBackButtonText:NSLocalizedString(@"Setting", nil)];
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].rootTabBarController.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

- (void)didClickRateButton:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WE_TONGJI_APP_STORE_URL]];
}

- (void)didClickFeedbackButton:(UIButton *)sneder {
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failure", nil)
                                                        message:@"You have not bound a email account to your device"
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"I see", nil)
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"微同济 3.0 用户反馈"];
    [picker.navigationBar setBarStyle:UIBarStyleBlack];
    
    NSArray *toRecipients = [NSArray arrayWithObjects:WE_TONGJI_EMAIL, nil];
    NSString *emailBody = @"请将需要反馈的信息填入邮件正文，您的宝贵建议会直接送达微同济开发团队。";
    [picker setToRecipients:toRecipients];
    [picker setMessageBody:emailBody isHTML:NO];
    [[UIApplication sharedApplication].meViewController presentViewController:picker animated:YES completion:nil];
}

- (void)didClickTutorialButton:(UIButton *)sender {
    [WTLoginViewController showWithIntro:YES];
}

- (void)didClickSwitchAccountButton:(UIButton *)sender {
    [WTLoginViewController showWithIntro:NO];
}

- (void)didClickTeamButton:(UIButton *)sender {
    WTTeamMemberViewController *vc = [[WTTeamMemberViewController alloc] init];
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].rootTabBarController.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

- (void)didClickChangePasswordButton:(UIButton *)sender {
    WTChangePasswordViewController *vc = [[WTChangePasswordViewController alloc] init];
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].rootTabBarController.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    [self.view endEditing:YES];
}

#pragma mark - UITextFiledDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSUInteger index = [self.textFieldArray indexOfObject:textField];
    if (NSNotFound != index) {
        if (index == self.textFieldArray.count - 1) {
            [self.textFieldArray[0] becomeFirstResponder];
        } else {
            [self.textFieldArray[index + 1] becomeFirstResponder];
        }
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.dormTextField) {
        [WTSelectDormViewController showWithDelegate:self];
        return NO;
    }
    return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView.message isEqualToString:NSLocalizedString(@"Are you sure you want to logout?", nil)]) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [[WTClient sharedClient] logout];
            [WTCoreDataManager sharedManager].currentUser = nil;
        }
    }
}

#pragma mark - MFMailComposeViewController delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    if(result == MFMailComposeResultSent) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil)
                                                        message:@"Your feedback has been delieved successfully"
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"I see", nil)
                                              otherButtonTitles:nil];
        [alert show];
    } else if(result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failure", nil)
                                                        message:@"Your feedback has not been delieved"
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"I see", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
	[[UIApplication sharedApplication].meViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RDActivityViewControllerDelegate

- (NSArray *)activityViewController:(NSArray *)activityViewController itemsForActivityType:(NSString *)activityType {
    NSString *defaultText = [NSString stringWithFormat:@"微同济 3.0 震撼来袭——好友系统，强力搜索，通知推送，课程旁听等精彩功能等你体验!下载地址:%@", WE_TONGJI_APP_STORE_URL];
    UIImage *defaultImage = [UIImage imageNamed:@"WTPropergate.jpg"];
    if ([activityType isEqualToString:UIActivityTypePostToWeibo]) {
        NSString *weiboText = [NSString stringWithFormat:@"%@ @WeTongji", defaultText];
        return @[weiboText, defaultImage];
    } else {
        return @[defaultText, defaultImage];
    }
}

#pragma mark - WTSelectDormViewControllerDelegate

- (void)selectDormViewController:(WTSelectDormViewController *)vc
             didSelectDistribute:(NSString *)distribute
                        building:(NSString *)building
                      roomNumber:(NSString *)roomNumber {
    NSString *dormString = [NSString stringWithFormat:@"%@ %@ %@", distribute, building, roomNumber];
    self.dormTextField.text = dormString;
    [[NSUserDefaults standardUserDefaults] setCurrentUserDorm:dormString];
}

@end
