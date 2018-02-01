//
//  ShareManager.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/16.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "ShareManager.h"

@implementation ShareManager
+ (void)shareWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    if (title) {
        [items addObject:title];
    }
    if (image) {
        [items addObject:image];
    }
    if (url) {
        [items addObject:url];
    }
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
//    NSMutableArray *excludedActivityTypes =  [NSMutableArray arrayWithArray:@[UIActivityTypeAirDrop, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeMail, UIActivityTypePostToTencentWeibo, UIActivityTypeSaveToCameraRoll, UIActivityTypeMessage, UIActivityTypePostToTwitter]];
//    activityViewController.excludedActivityTypes = excludedActivityTypes;
    [kRootNavigation presentViewController:activityViewController animated:YES completion:nil];
    activityViewController.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        NSLog(@"%@  ----   %@", activityType, returnedItems);
    };
}
@end
