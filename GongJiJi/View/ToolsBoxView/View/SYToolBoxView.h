//
//  JZToolBoxView.h
//  Jiazheng
//
//  Created by zhangzhigang on 16/2/25.
//  Copyright © 2016年 58. All rights reserved.
//  modify  by   yangshaohua

#define kJZToolBoxViewWidth   120
#import <UIKit/UIKit.h>
#import "SYPageModel.h"

@interface SYToolBoxView : UIView
@property (nonatomic, weak) id delegate;
- (instancetype)initWithPage:(SYPageModel *)pageModel;

@end



@protocol JZToolBoxViewDelegate <NSObject>

- (void)didJZToolBoxViewClickButtonAtIndex:(NSInteger)index;

@end
