//
//  WEMeEditViewController.m
//  WeCampus
//
//  Created by Song on 13-8-26.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEMeEditViewController.h"
#import "User+Addition.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AsyncLoading.h"
#import "WEMeEditPhotoSourceSelectViewController.h"

@interface WEMeEditViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,WEMeEditPhotoSourceSelectViewControllerDelegate>

@end

@implementation WEMeEditViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureWithUser:(User*)user
{
    self.user = user;
    self.mobileTextField.text = user.motto;
    self.mobileTextField.text = user.phoneNumber;
    self.emailTextField.text = user.emailAddress;
    self.qqTextField.text = user.qqAccount;
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.bounds.size.width / 2;
    [self.headImageView loadImageWithImageURLString:user.avatar];
}

- (IBAction)cancelPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)savePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeAvaterTapped:(id)sender
{
    WEMeEditPhotoSourceSelectViewController *vc = [[WEMeEditPhotoSourceSelectViewController alloc] init];
    [self addChildViewController:vc];
    vc.delegate = self;
    [vc.view setFrame:self.view.bounds];
    [self.view addSubview:vc.view];
}

#pragma mark WEMeEditPhotoSourceSelectViewControllerDelegate
- (void)didClickCancel
{
    
}

- (void)didClickCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)didClickLibrary
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


#pragma mark 
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.headImageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
