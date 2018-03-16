//
//  JZMoreOptionView.h
//  SuYunDriver
//
//  Created by yangshaohua on 2017/8/12.
//  Copyright © 2017年 58SuYun. All rights reserved.
//  modify  by   yangshaohua

#import <UIKit/UIKit.h>
#import "SYPageModel.h"
@interface SYMoreOptionView : UIView
@property (nonatomic, strong) SYPageModel     *pageModel;
@property (nonatomic, weak) id                 delegate;

- (void)show;
@end



@protocol JZMoreOptionViewDelegate <NSObject>

- (void)didJZMoreOptionViewClickAtIndex:(NSInteger)index;

@end
