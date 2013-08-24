//
//  WEAboutViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-18.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEAboutViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "UIApplication+WTAddition.h"

#define WE_TONGJI_EMAIL             @"wetongji2012@gmail.com"
#define WE_TONGJI_SINA_WEIBO_URL    @"http://www.weibo.com/wetongji"
#define WE_TONGJI_APP_STORE_URL     @"http://itunes.apple.com/cn/app/id526260090?mt=8"

@interface WEAboutViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation WEAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"关于";
    
    [self configureScrollView];
}

- (void)configureScrollView
{
    [self.scrollView resetHeight:self.view.frame.size.height];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 30);
    [self.scrollView setContentOffset:CGPointZero];
    
    [self.copyrightLabel resetOriginY:self.view.frame.size.height - 50];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)didClickUserProtocol:(id)sender
{
   
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
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didClickShare:(id)sender
{
    
}

- (IBAction)didClickSuggest:(id)sender
{
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
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

@end
