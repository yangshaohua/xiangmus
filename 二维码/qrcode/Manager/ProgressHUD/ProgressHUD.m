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

#import "ProgressHUD.h"


@implementation ProgressHUD

static NSUInteger _isShow;

@synthesize window, hud, spinner, image, label;
@synthesize preferSize , font ;
//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (ProgressHUD *)shared
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	static dispatch_once_t once = 0;
	static ProgressHUD *progressHUD;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dispatch_once(&once, ^{ progressHUD = [[ProgressHUD alloc] init]; });
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return progressHUD;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)dismiss
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[[self shared] hudHide];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)show:(NSString *)status
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if(_isShow == NO)
    {
        _isShow = YES;
        [[self shared] hudMake:status style:ProgressStyleText hide:YES];
    }
}
//zhulinfang
+ (void)show:(NSString *)status completion:(void (^)(void))completion
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if(_isShow == NO)
    {
        _isShow = YES;
        [[self shared] hudMake:status style:ProgressStyleText hide:YES completion:completion];
    }
}

+ (void)showLoading:(NSString *)status
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[[self shared] hudMake:status style:ProgressStyleLoading  hide:NO];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)showSuccess:(NSString *)status
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[[self shared] hudMake:status style:ProgressStyleSucess hide:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)showError:(NSString *)status
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    
        [[self shared] hudMake:status style:ProgressStyleError hide:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id)init
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([delegate respondsToSelector:@selector(window)])
		window = [delegate performSelector:@selector(window)];
	else window = [[UIApplication sharedApplication] keyWindow];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	hud = nil; spinner = nil; image = nil; label = nil;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.alpha = 0;
	//---------------------------------------------------------------------------------------------------------------------------------------------
    self.preferSize = CGSizeMake(100, 50) ;
    _isShow = NO;
    return self;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)hudMake:(NSString *)status style:(ProgressStyle)style  hide:(BOOL)hide
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    self.style = style ;
    
	[self hudCreate];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	label.text = status;
	label.hidden = (status == nil) ? YES : NO;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	switch (style) {
        case ProgressStyleText:
        case ProgressStyleLoading:
            image.image = nil ;
            break;
        case ProgressStyleSucess:{
            image.image = HUD_IMAGE_SUCCESS ;
            break;
        }
        case ProgressStyleError:
            image.image = HUD_IMAGE_ERROR ;
            break;
        default:
            break;
    }
	image.hidden = (image.image == nil) ? YES : NO;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (style == ProgressStyleLoading ) [spinner startAnimating]; else [spinner stopAnimating];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self hudOrient];
	[self hudSize];
	[self hudShow];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (hide) [NSThread detachNewThreadSelector:@selector(timedHide) toTarget:self withObject:nil];
}

//zhulinafng
- (void)hudMake:(NSString *)status style:(ProgressStyle)style  hide:(BOOL)hide completion:(void (^)(void))completion
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    self.style = style ;
    
    [self hudCreate];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    label.text = status;
    label.hidden = (status == nil) ? YES : NO;
    //---------------------------------------------------------------------------------------------------------------------------------------------
    switch (style) {
        case ProgressStyleText:
        case ProgressStyleLoading:
            image.image = nil ;
            break;
        case ProgressStyleSucess:{
            image.image = HUD_IMAGE_SUCCESS ;
            break;
        }
        case ProgressStyleError:
            image.image = HUD_IMAGE_ERROR ;
            break;
        default:
            break;
    }
    image.hidden = (image.image == nil) ? YES : NO;
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if (style == ProgressStyleLoading ) [spinner startAnimating]; else [spinner stopAnimating];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [self hudOrient];
    [self hudSize];
    [self hudShow];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if (hide) [NSThread detachNewThreadSelector:@selector(timedHideCompletion:) toTarget:self withObject:completion];
}

- (void)timedHideCompletion:(void (^)(void))completion
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    @autoreleasepool
    {
        double length = label.text.length;
        NSTimeInterval sleep = length * 0.1 + 0.5;
        
        if (self.showForTime > 0) {
            sleep = self.showForTime;
        }
        if (sleep < 1) {
            sleep = 1;
        }
        
        [NSThread sleepForTimeInterval:sleep];
        [self hudHide];
        _isShow = NO;
        self.showForTime = 0;
        completion();
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)hudCreate
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (hud == nil)
	{
		hud = [[UIToolbar alloc] initWithFrame:CGRectZero];
        if ( [hud respondsToSelector:@selector(setBarTintColor:)]) {
            if ( self.hudColor != nil ) {
                hud.barTintColor = self.hudColor ;
            }else
                hud.barTintColor = HUD_BACKGROUND_COLOR;
        }else{//iOS5
            if ( self.hudColor != nil ) {
                hud.backgroundColor = self.hudColor ;
            }else
                hud.backgroundColor = HUD_BACKGROUND_COLOR;
            NSString *main_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DJSuyunLib.bundle"];
            //    NSAssert(main_images_dir_path, @"main_images_dir_path is null");
            NSString *image_path = [main_images_dir_path stringByAppendingString:@"/ProgressHUD/halfBlack.png"];
            UIImage *toolBarIMG = [UIImage imageWithContentsOfFile:image_path];
            [hud setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
        }
		hud.translucent = YES ;
		hud.layer.cornerRadius = 10;
		hud.layer.masksToBounds = YES;
        hud.alpha = 0.95 ;
		//-----------------------------------------------------------------------------------------------------------------------------------------
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
	}
	if (hud.superview == nil) [window addSubview:hud];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (spinner == nil)
	{
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.frame = CGRectMake(0, 0, 28, 28);
		spinner.color = HUD_SPINNER_COLOR;
		spinner.hidesWhenStopped = YES;
	}
   	if (spinner.superview == nil) [hud addSubview:spinner];
   
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (image == nil && self.style != ProgressStyleText )
	{
        //		image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 62, 62)];
	}
	if (image.superview == nil) [hud addSubview:image];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (label == nil)
	{
		label = [[UILabel alloc] initWithFrame:CGRectZero];
        if ( font == nil ) {
            label.font = HUD_STATUS_FONT;
        }else{
            label.font = font ;
        }
		label.textColor = HUD_STATUS_COLOR;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		label.numberOfLines = 0;
	}
	if (label.superview == nil) [hud addSubview:label];
	//---------------------------------------------------------------------------------------------------------------------------------------------
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)hudDestroy
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[label removeFromSuperview];	label = nil;
	[image removeFromSuperview];	image = nil;
	[spinner removeFromSuperview];	spinner = nil;
    

	[hud removeFromSuperview];		hud = nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)rotate:(NSNotification *)notification
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self hudOrient];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)hudOrient
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	CGFloat rotate;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	UIInterfaceOrientation orient = [[UIApplication sharedApplication] statusBarOrientation];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (orient == UIInterfaceOrientationPortrait)			rotate = 0.0;
	if (orient == UIInterfaceOrientationPortraitUpsideDown)	rotate = M_PI;
	if (orient == UIInterfaceOrientationLandscapeLeft)		rotate = - M_PI_2;
	if (orient == UIInterfaceOrientationLandscapeRight)		rotate = + M_PI_2;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	hud.transform = CGAffineTransformMakeRotation(rotate);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)hudSize
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	CGRect labelRect = CGRectZero;
	CGFloat hudWidth = self.preferSize.width, hudHeight = self.preferSize.height ;
    
    CGFloat labelY_offset = 0 ; //图片
    
    if ( self.style != ProgressStyleText ) {
        labelY_offset += 60 ;
    }
    
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (label.text != nil)
	{
        if ( [label.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)] ) { //iOS7
            NSDictionary *attributes = [[NSDictionary alloc] initWithObjectsAndKeys:label.font,NSFontAttributeName , nil ];//@{NSFontAttributeName:label.font};
            NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
            labelRect = [label.text boundingRectWithSize:CGSizeMake(270, 300) options:options attributes:attributes context:NULL];
        }else{
            CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(270, 300) lineBreakMode:UILineBreakModeCharacterWrap ];
            labelRect.size = size ;
        }
        
		labelRect.origin.x = 12;
		labelRect.origin.y = labelY_offset ;
        
		hudWidth = labelRect.size.width + 24;
		hudHeight = labelRect.size.height + labelY_offset  ;
        
		if (hudWidth < self.preferSize.width)
		{
			hudWidth = self.preferSize.width ;
			labelRect.origin.x = 0;
			labelRect.size.width = self.preferSize.width ;
		}
        if ( hudHeight < self.preferSize.height) {
            labelRect.origin.y += (  self.preferSize.height  - hudHeight ) /2 ;
            hudHeight = self.preferSize.height ;
            
        }
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	CGSize screen = [UIScreen mainScreen].bounds.size;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	hud.center = CGPointMake(screen.width/2, screen.height/2);
    
    if ( self.style != ProgressStyleText ) {
        
                if ( hudWidth < 270 ) {
                    hudWidth += 70 ;
                }
        hudHeight = 130 ;
        
        labelRect.origin.x = 0;
        labelRect.origin.y += 43 ;
        labelRect.size.width = hudWidth ;
//        label.font = [UIFont systemFontOfSize:20 ] ;
        label.backgroundColor = [UIColor clearColor ];
        label.textAlignment = NSTextAlignmentCenter ;
    }
	//---------------------------------------------------------------------------------------------------------------------------------------------
	
    if( self.style == ProgressStyleSucess || self.style == ProgressStyleError ){
        CGFloat imagex = hudWidth/2;
//        CGFloat imagey = (label.text == nil) ? hudHeight/2 : 50;
        CGFloat imagey = (label.text == nil) ? hudHeight/2 : 63;
        image.center = spinner.center = CGPointMake(imagex, imagey);
        hudHeight += 20 ;
        
    }
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if( self.style == ProgressStyleLoading ){
//        if ( hudWidth < 170 ) {
//            hud.bounds = CGRectMake(0, 0, 170, hudHeight );
//        }
        
        CGFloat imagex = hudWidth/2;
//        CGFloat imagey = (label.text == nil) ? hudHeight/2 : 50;
        CGFloat imagey = (label.text == nil) ? hudHeight/2 : 55;
        spinner.center = spinner.center = CGPointMake(imagex, imagey);
        labelRect.origin.y -= 20 ;
    }
    hud.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
    label.frame = labelRect;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)hudShow
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (self.alpha == 0)
	{
		self.alpha = 0.85;
        
		hud.alpha = 0;
		hud.transform = CGAffineTransformScale(hud.transform, 1.4, 1.4);
        
		NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut;
        
		[UIView animateWithDuration:0.25 delay:0 options:options animations:^{
			hud.transform = CGAffineTransformScale(hud.transform, 1/1.4, 1/1.4);
			hud.alpha = 0.95;
		}
                         completion:^(BOOL finished){ }];
    }
}
- (void)_executeShowAnimation:(CAAnimation *)animation{
    [animation setValue:@"ProgressHUDAnimationShow" forKey:@"name"];
    
    //    self.visible = YES;
    
    typeof(self) __weak weakSelf = self;
    void(^showCompletion)(void) = ^(void){
        ProgressHUD * blockSelf = weakSelf;
        //        NSLog(@"Show animation ended: %@", blockSelf.hud);
        
        //        if (blockSelf.queuedDismissAnimation != nil) {
        //            [blockSelf _executeDismissAnimation:blockSelf.queuedDismissAnimation];
        //            blockSelf.queuedDismissAnimation = nil;
        //        }
    };
    
    //    if ([self.hud.layer animationForKey:MMProgressHUDAnimationKeyDismissAnimation] != nil) {
    //        self.queuedShowAnimation = animation;
    //    }
    //    else if([self.hud.layer animationForKey:MMProgressHUDAnimationKeyShowAnimation] == nil){
    //        self.queuedShowAnimation = nil;
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:showCompletion];
    {
        [self.hud.layer addAnimation:animation forKey: @"ProgressHUDAnimationKeyShowAnimation" ];
    }
    [CATransaction commit];
    //    }
}

- (CAKeyframeAnimation *)_dropInAnimationPositionAnimationWithCenter:(CGPoint)newCenter {
    CAKeyframeAnimation *dropInPositionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.hud.center.x, self.hud.center.y);
    CGPathAddLineToPoint(path, NULL, newCenter.x - 10.f, newCenter.y - 2.f);
    CGPathAddCurveToPoint(path, NULL,
                          newCenter.x, newCenter.y - 10.f,
                          newCenter.x + 10.f, newCenter.y - 10.f,
                          newCenter.x + 5.f, newCenter.y - 2.f);
    CGPathAddCurveToPoint(path, NULL,
                          newCenter.x + 7, newCenter.y - 7.f,
                          newCenter.x, newCenter.y - 7.f,
                          newCenter.x - 3.f, newCenter.y);
    CGPathAddCurveToPoint(path, NULL,
                          newCenter.x, newCenter.y - 4.f,
                          newCenter.x , newCenter.y - 4.f,
                          newCenter.x, newCenter.y);
    
    dropInPositionAnimation.path = path;
    dropInPositionAnimation.calculationMode = kCAAnimationCubic;
    dropInPositionAnimation.keyTimes = @[@0.0f,
                                         @0.25f,
                                         @0.35f,
                                         @0.55f,
                                         @0.7f,
                                         @1.0f];
    dropInPositionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CGPathRelease(path);
    
    return dropInPositionAnimation;
}

- (CAAnimation *)_fadeAnimationIn{
    
    CATransition *showAnimation = [CATransition animation ];
    showAnimation.duration = 1.0 ;
    //    showAnimation.type = @"fade"; //default
    
    [self _executeShowAnimation:showAnimation];
    
    
    return showAnimation;
}


- (CAAnimation *)_dropAnimationIn{
    CGFloat initialAngle = M_2_PI/10.f + arc4random_uniform(1000)/1000.f*M_2_PI/5.f;
    
    UIWindow *keyWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
    GLfloat offset = self.hud.frame.size.height/2 ;
    CGPoint newCenter = CGPointMake(keyWindow.bounds.size.width/2 , keyWindow.bounds.size.height/2 - offset  );
    
    NSLog(@"Center after drop animation: %@", NSStringFromCGPoint(newCenter));
    
    CAKeyframeAnimation *dropInAnimation = [self _dropInAnimationPositionAnimationWithCenter:newCenter];
    CAKeyframeAnimation *rotationAnimation = [self _dropInAnimationRotationAnimationWithInitialAngle:initialAngle
                                                                                            keyTimes:dropInAnimation.keyTimes];
    
    CAAnimationGroup *showAnimation = [CAAnimationGroup animation];
    showAnimation.animations = @[dropInAnimation, rotationAnimation];
    showAnimation.duration = 0.5;
    
    [self _executeShowAnimation:showAnimation];
    
    self.hud.layer.position = newCenter;
    self.hud.layer.transform = CATransform3DIdentity;
    
    return showAnimation;
}
- (CAKeyframeAnimation *)_dropInAnimationRotationAnimationWithInitialAngle:(CGFloat)initialAngle keyTimes:(NSArray *)keyTimes{
    CAKeyframeAnimation *rotation = [CAKeyframeAnimation animationWithKeyPath:@"rotation.z"];///transform.rotation.z
    rotation.values = @[@(initialAngle),
                        @(-initialAngle * 0.85),
                        @(initialAngle * 0.6),
                        @(-initialAngle * 0.3),
                        @0.f];
    rotation.calculationMode = kCAAnimationCubic;
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotation.keyTimes = keyTimes;
    
    return rotation;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)hudHide
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (self.alpha > 0)
	{
#warning 测试代码。
		
//        hud.alpha = 0;
//        [self hudDestroy];
//        self.alpha = 0;
        NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn;
        [UIView animateWithDuration:0.15 delay:0 options:options animations:^{
            hud.alpha = 0;
        }
                         completion:^(BOOL finished)
         {
             [self hudDestroy];
             self.alpha = 0;
         }];
	}
}


- (void)_executeDismissAnimation:(CAAnimation *)animation{
    [animation setValue:@"drop-out-animation" forKey:@"name"];
    
    typeof(self) __weak weakSelf = self;
    void(^endCompletion)(void) = ^(void){
        ProgressHUD *blockSelf = weakSelf;
        NSLog(@"Dismiss animation ended");
        
        //        if (blockSelf.dismissAnimationCompletion != nil) {
        //            blockSelf.dismissAnimationCompletion();
        //        }
        
        [blockSelf.hud removeFromSuperview];
        
        //        blockSelf.queuedDismissAnimation = nil;
        
        //reset for next presentation
        //        [blockSelf.hud prepareForReuse];
        
        //        if (blockSelf.queuedShowAnimation != nil) {
        //            [blockSelf _executeShowAnimation:blockSelf.queuedShowAnimation];
        //        }
    };
    
    //    if ([self.hud.layer animationForKey:MMProgressHUDAnimationKeyShowAnimation] != nil) {
    //        self.queuedDismissAnimation = animation;
    //    }
    //    else if([self.hud.layer animationForKey:MMProgressHUDAnimationKeyDismissAnimation] == nil){
    //        self.queuedDismissAnimation = nil;
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:endCompletion];
    {
        [self.hud.layer addAnimation:animation forKey:@"ProgressHUDAnimationKeyDismissAnimation"];
    }
    [CATransaction commit];
    //    }
}

- (CAAnimation *)_dropAnimationOut{
    double newAngle = arc4random_uniform(1000)/1000.f*M_2_PI-(M_2_PI)/2.f;
    CATransform3D rotation = CATransform3DMakeRotation(newAngle, 0.f, 0.f, 1.f);
    CGPoint newPosition = CGPointMake(self.hud.layer.position.x, self.frame.size.height + self.hud.frame.size.height);
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotationAnimation.fromValue = [NSValue valueWithCATransform3D:self.hud.layer.transform];
    rotationAnimation.toValue = [NSValue valueWithCATransform3D:rotation];
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:self.hud.layer.position];
    positionAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
    
    CAAnimationGroup *fallOffAnimation = [CAAnimationGroup animation];
    fallOffAnimation.animations = @[rotationAnimation, positionAnimation];
    fallOffAnimation.duration = 0.5f ;
    fallOffAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    fallOffAnimation.removedOnCompletion = YES;
    
    return fallOffAnimation;
}
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)timedHide
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	@autoreleasepool
	{
        dispatch_async(dispatch_get_main_queue(), ^{
            double length = label.text.length;
            NSTimeInterval sleep = length * 0.1 + 0.5;
            
            if (self.showForTime > 0) {
                sleep = self.showForTime;
            }
            if (sleep < 1) {
                sleep = 1;
            }
            
            [NSThread sleepForTimeInterval:sleep];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hudHide];
            });
            
            _isShow = NO;
            self.showForTime = 0;
        });
		
	}
}

@end
