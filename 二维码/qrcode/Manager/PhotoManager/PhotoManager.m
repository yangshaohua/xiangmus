//
//  PhotoManager.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/14.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "PhotoManager.h"
@interface PhotoManager ()
{
    UIImagePickerController *picker;
}
@end
@implementation PhotoManager
+ (instancetype)sharedInstance
{
    static PhotoManager *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[PhotoManager alloc] init];
    });
    return mediator;
}

- (instancetype)init
{
    if (self = [super init]) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            switch (status) {
                case PHAuthorizationStatusAuthorized:
                    NSLog(@"PHAuthorizationStatusAuthorized");
                    break;
                case PHAuthorizationStatusDenied:
                    NSLog(@"PHAuthorizationStatusDenied");
                    break;
                case PHAuthorizationStatusNotDetermined:
                    NSLog(@"PHAuthorizationStatusNotDetermined");
                    break;
                case PHAuthorizationStatusRestricted:
                    NSLog(@"PHAuthorizationStatusRestricted");
                    break;
            }
        }];
        
        picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing = YES;
       
    }
    return self;
}


#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        
        [picker dismissViewControllerAnimated:NO completion:^{
            
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    });
}

- (void)takePhoto
{
    [kRootNavigation presentViewController:picker animated:YES completion:^{
        
    }];
}
@end
