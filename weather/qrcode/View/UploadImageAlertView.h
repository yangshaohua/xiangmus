//
//  UploadImageAlertView.h
//  CustomAlertView
//
//  Created by changpengkai on 16/8/9.
//  Copyright © 2016年 com.pengkaichang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonClickBlock)(NSInteger index);

@interface UploadImageAlertView : UIView
@property (nonatomic, strong) NSArray *buttonTitles;
@property (nonatomic, copy) ButtonClickBlock buttonClickBlock;
+ (id)upLoadImageAlertView;
- (void)show;
- (void)dismiss;
@end
