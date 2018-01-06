//
//  JZToolView.h
//  Jiazheng
//
//  Created by zhangzhigang on 16/2/25.
//  Copyright © 2016年 58. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYToolModel.h"

@interface SYToolView : UIView
@property(nonatomic, strong)UIButton *button;
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UILabel     *titleLabel;
@property(nonatomic, strong)SYToolModel *toolModel;
- (instancetype)initWithTool:(SYToolModel *)toolModel;

@end
