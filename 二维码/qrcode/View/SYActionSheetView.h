//
//  SYActionSheetView.h
//  SuYunDriver
//
//  Created by yangshaohua on 2017/8/10.
//  Copyright © 2017年 58SuYun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYActionSheetView;
@protocol SYActionSheetViewDelegate <NSObject>
- (NSInteger)numberOfRowsInActionSheetView:(SYActionSheetView *)actionSheetView;

- (CGFloat)actionSheetView:(SYActionSheetView *)actionSheetView heightforRowIndex:(NSInteger)index;

- (UIView *)actionSheetView:(SYActionSheetView *)actionSheetView viewforRowIndex:(NSInteger)index;

- (CGFloat)actionSheetViewHeightForFooter:(SYActionSheetView *)actionSheetView;

- (UIView *)actionSheetViewViewForFooter:(SYActionSheetView *)actionSheetView;

- (void)actionSheetView:(SYActionSheetView *)actionSheetView didClickViewAtIndex:(NSInteger)index;
@end

@interface SYActionSheetView : UIView
@property (nonatomic, weak) id delegate;
@property (assign, nonatomic) CGFloat leftMargin;
@property (assign, nonatomic) CGFloat rightMargin;
@property (nonatomic, assign) CGFloat   rowHeight;
@property (nonatomic, assign) CGFloat   cornerRadius;

- (void)show;
- (void)dismiss;
- (void)reloadData;
- (UIView *)viewWithIndex:(NSInteger)index;

@end
