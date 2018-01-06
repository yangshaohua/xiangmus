//
// Copyright (c) 2013 Related Code - http://relatedcode.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//-------------------------------------------------------------------------------------------------------------------------------------------------
//#define sheme_white
#define sheme_black
//-------------------------------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define HUD_STATUS_FONT			[UIFont boldSystemFontOfSize:16]
//-------------------------------------------------------------------------------------------------------------------------------------------------
#ifdef sheme_white
#define HUD_STATUS_COLOR		[UIColor blackColor]
#define HUD_SPINNER_COLOR		[UIColor blackColor]
#define HUD_BACKGROUND_COLOR	[UIColor colorWithWhite:1 alpha:0.75]
#define HUD_IMAGE_SUCCESS		[UIImage imageNamed:@"success-white"]
#define HUD_IMAGE_ERROR			[UIImage imageNamed:@"error-white"]
#endif
//-------------------------------------------------------------------------------------------------------------------------------------------------
#ifdef sheme_black
#define HUD_STATUS_COLOR		[UIColor whiteColor]
#define HUD_SPINNER_COLOR		[UIColor whiteColor ] //colorWithRed:0xd5/255 green:0xd7/255 blue:0xda/255 alpha:1 ]
#define HUD_BACKGROUND_COLOR	[UIColor colorWithWhite:0 alpha:0.75] //[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75 ] //
#define HUD_IMAGE_SUCCESS		[UIImage imageNamed:@"success-black"]
#define HUD_IMAGE_ERROR			[UIImage imageNamed:@"error-black.png"]
#endif
//-------------------------------------------------------------------------------------------------------------------------------------------------

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef enum{
    ProgressStyleText,
    ProgressStyleLoading,
    ProgressStyleSucess,
    ProgressStyleError
}ProgressStyle ;

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface ProgressHUD : UIView
//-------------------------------------------------------------------------------------------------------------------------------------------------

+ (ProgressHUD *)shared;

+ (void)dismiss;
+ (void)show:(NSString *)status;
//zhulinfang
+ (void)show:(NSString *)status completion:(void (^ )(void))completion;

+ (void)showSuccess:(NSString *)status;
+ (void)showError:(NSString *)status;
+ (void)showLoading:(NSString *)status;

@property (atomic, strong) UIWindow *window;
@property (atomic, strong) UIToolbar *hud;
@property (atomic, strong) UIActivityIndicatorView *spinner;
@property (atomic, strong) UIImageView *image;
@property (atomic, strong) UILabel *label;
@property CGSize preferSize;
@property (atomic, strong) UIFont *font ;
@property (atomic, strong) UIColor *hudColor ;
@property (atomic, assign) NSTimeInterval showForTime;

@property ProgressStyle style ;
@end
