//
//  PhotoManager.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/14.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "PhotoManager.h"
@interface PhotoManager ()

@property (strong, nonatomic) UIImagePickerController *picker;
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

- (void)dealloc {
    
}

- (instancetype)init
{
    if (self = [super init]) {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.picker addObserver:self forKeyPath:@"delegate" options:NSKeyValueObservingOptionNew context:nil];

        self.picker.delegate = self;
        self.picker.allowsEditing = YES;
       
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{

    NSLog(@"aaaaa %@", change[NSKeyValueChangeNewKey]);
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
    [kRootNavigation presentViewController:self.picker animated:YES completion:^{
        
    }];
}
@end
