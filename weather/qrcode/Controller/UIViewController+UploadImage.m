

//
//  SNViewController+UploadImage.m
//  RaidersQA
//
//  Created by shaohua6 on 15/8/24.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import "UIViewController+UploadImage.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import "UploadImageAlertView.h"

static char *previousBarStyleKey = "previousBarStyleKey";

@interface UIViewController ()
@property (nonatomic, retain) NSNumber *previousBarStyle;
@end

@implementation UIViewController (UploadImage)

- (NSNumber *)previousBarStyle {
    
    return objc_getAssociatedObject(self, &previousBarStyleKey);
}

- (void)setPreviousBarStyle:(NSNumber *)previousBarStyle {
    objc_setAssociatedObject(self, &previousBarStyleKey, previousBarStyle, OBJC_ASSOCIATION_RETAIN);
}

- (void)headImageClick
{
    self.previousBarStyle = [NSNumber numberWithInteger:[[UIApplication sharedApplication]statusBarStyle]];
    UploadImageAlertView *alertView = [UploadImageAlertView upLoadImageAlertView];
    
    alertView.buttonTitles = [NSArray arrayWithObjects:NSLocalizedString(@"Take Photo", nil), NSLocalizedString(@"Photo Library", nil), NSLocalizedString(@"cancel", nil), nil];
    alertView.buttonClickBlock = ^ (NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            // 拍照
            [self takePhoto];
        }else if (buttonIndex == 1) {
            // 从手机相册选取
             [self LocalPhoto];
        }
        
    };
    [alertView show];
}

#pragma mark 照片选择
-(void)takePhoto
{
    if ( AVAuthorizationStatusDenied == [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Setting Permission for recording in Settings -> Privacy -> phone", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"confirm", nil), nil];
        [alertView show];
        return;
    }
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: sourceType])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = [self isImageAllowEditing];
        picker.sourceType = sourceType;
        [kRootNavigation presentViewController:picker animated:YES completion:^{
            [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
        }];
    }else
    {
        
    }
}

-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = [self isImageAllowEditing];
    [kRootNavigation presentViewController:picker animated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    }];
}

- (BOOL)isImageAllowEditing
{
    return NO;
}
#pragma mark
#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage *image = nil;
        if ([self isImageAllowEditing]) {
            image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        }else{
            image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        }
    
        [[UIApplication sharedApplication] setStatusBarStyle:self.previousBarStyle.integerValue];
        [picker dismissViewControllerAnimated:NO completion:^{
            if ([self respondsToSelector:@selector(photoDidSelectImage:imageUrl:)]) {
                [self photoDidSelectImage:image imageUrl:url];
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:self.previousBarStyle.integerValue];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
