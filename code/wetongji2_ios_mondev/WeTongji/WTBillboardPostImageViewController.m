//
//  WTBillboardPostImageViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-17.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBillboardPostImageViewController.h"
#import "WTResourceFactory.h"
#import <QuartzCore/QuartzCore.h>

@interface WTBillboardPostImageViewController () <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

@end

@implementation WTBillboardPostImageViewController

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
    [self configureTitleView];
    [self configurePostImageView];
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    [super configureNavigationBar];
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Photo", nil)];
}

- (void)configureTitleView {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.titleBgImageView.image = bgImage;
    
    UIButton *lockButton = [WTResourceFactory createLockButtonWithTarget:self action:@selector(didClickLockButton:)];
    [lockButton resetOriginX:self.titleBgView.frame.size.width - lockButton.frame.size.width - 7.0f];
    [lockButton resetCenterY:self.titleBgView.frame.size.height / 2];
    [self.titleBgView addSubview:lockButton];
    
    [self.titleTextField becomeFirstResponder];
}

- (void)configurePostImageView {
    self.postImageView.layer.masksToBounds = YES;
    self.postImageView.layer.cornerRadius = 6.0f;
}

#pragma mark - Actions

- (IBAction)didClickPickImageFromCameraButton:(UIButton *)sender {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentModalViewController:ipc animated:YES];
}

- (IBAction)didClickPickImageFromLibraryButton:(UIButton *)sender {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:ipc animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == actionSheet.cancelButtonIndex)
        return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    
    if(buttonIndex == 1) {
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if(buttonIndex == 0) {
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentModalViewController:ipc animated:YES];
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *edittedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    self.postImageView.image = edittedImage;
}

@end
