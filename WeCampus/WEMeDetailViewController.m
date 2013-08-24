//
//  WEMeDetailViewController.m
//  WeCampus
//
//  Created by Song on 13-8-24.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEMeDetailViewController.h"
#import "NSDate+WTAddition.h"
#import "UIImageView+AsyncLoading.h"
#import <QuartzCore/QuartzCore.h>
#import "WTCoreDataManager.h"
#import <RHAddressBook/RHAddressBook.h>
#import <RHPerson.h>
#import <AddressBook/AddressBook.h>

@interface WEMeDetailViewController ()
{
    User* _user;
}
@end

@implementation WEMeDetailViewController

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
    [self configureWithUser:_user];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.scrollView addSubview:self.contentView];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popCLicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveAsContact:(id)sender
{
    RHAddressBook *ab = [[RHAddressBook alloc] init];
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusNotDetermined){
        
        //request authorization
        [ab requestAuthorizationWithCompletion:^(bool granted, NSError *error) {
            //[abViewController setAddressBook:ab];
        }];
    }
    
    RHPerson *person = [ab newPersonInDefaultSource];
    if(_user.name)
        [person setFirstName:_user.name];
    if(self.headImageView.image)
        [person setImage:self.headImageView.image];
    if(_user.department)
        [person setDepartment:_user.department];
    if(_user.birthday)
        [person setBirthday:_user.birthday];
    
    if(_user.phoneNumber && ![_user.phoneNumber isEqualToString:@""])
    {
        RHMultiStringValue *phoneMultiValue = [person phoneNumbers];
        RHMutableMultiStringValue *mutablePhoneMultiValue = [phoneMultiValue mutableCopy];
        if (! mutablePhoneMultiValue) mutablePhoneMultiValue = [[RHMutableMultiStringValue alloc] initWithType:kABMultiStringPropertyType];
        
        //RHPersonPhoneIPhoneLabel casts kABPersonPhoneIPhoneLabel to the correct toll free bridged type, see RHPersonLabels.h
        [mutablePhoneMultiValue addValue:_user.phoneNumber withLabel:RHPersonPhoneMobileLabel];
        person.phoneNumbers = mutablePhoneMultiValue;
    }
    if(_user.qqAccount && ![_user.qqAccount isEqualToString:@""])
    {
        RHMutableMultiStringValue *qqMultiValue = [[RHMutableMultiStringValue alloc] initWithType:kABMultiStringPropertyType];
        
        [qqMultiValue addValue:_user.qqAccount withLabel:RHPersonInstantMessageServiceQQ];
        [person setInstantMessageServices:qqMultiValue];
    }
    if(_user.emailAddress && ![_user.emailAddress isEqualToString:@""])
    {
        RHMutableMultiStringValue *emailMultiValue = [[RHMutableMultiStringValue alloc] initWithType:kABMultiStringPropertyType];
        
        [emailMultiValue addValue:_user.emailAddress withLabel:RHWorkLabel];
        [person setEmails:emailMultiValue];
    }
      
    [ab addPerson:person];
    NSError* error = nil;
    [ab saveWithError:&error];
    if(!error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"成功", nil) message:NSLocalizedString(@"联系人保存成功", nil)  delegate:nil cancelButtonTitle:NSLocalizedString(@"好的", nil)  otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"失败", nil) message:NSLocalizedString(@"联系人保存失败", nil)  delegate:nil cancelButtonTitle:NSLocalizedString(@"好的", nil)  otherButtonTitles: nil];
        [alert show];
    }
}

- (void)configureWithUser:(User*)user
{
    _user = user;
    self.nameLabel.text = user.name;
    self.mobileLabel.text = user.motto;
    self.birthdayLabel.text = [user.birthday convertToYearMonthDayString];
    self.numberLabel.text = user.studentNumber;
    self.schoolLabel.text = user.major;
    self.departmentLabel.text = user.department;
    self.mobileLabel.text = user.phoneNumber;
    self.emailLabel.text = user.emailAddress;
    self.qqLabel.text = user.qqAccount;
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.bounds.size.width / 2;
    [self.headImageView loadImageWithImageURLString:user.avatar];
    
    if(user == [WTCoreDataManager sharedManager].currentUser)
    {
        self.saveAsContactView.hidden = YES;
    }
}

@end
