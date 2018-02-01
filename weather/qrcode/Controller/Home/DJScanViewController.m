//
//  DJScanViewController.m
//  Jiazheng
//
//  Created by liuy on 2017/9/18.
//  Copyright © 2017年 58. All rights reserved.
//

#import "DJScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SYTopNaviBarView.h"
#import "ScanResultViewController.h"
#import "PhotoManager.h"
#import "UIViewController+UploadImage.h"
#import "CreateViewController.h"
@import GoogleMobileAds;
#define scanWidth  kScreenSize.width * 0.744
#define scanRect CGRectMake((kScreenSize.width - scanWidth) / 2, kScreenSize.height * 0.214, scanWidth, scanWidth)

static const char *kScanQRCodeQueueName = "ScanQRCodeQueue";
static SystemSoundID soundID = 0;

@interface DJScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL _isHandlerResult;
    
}
@property (strong, nonatomic) UIImagePickerController *picker;
@property(nonatomic, strong) GADBannerView *bannerView;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, assign) AVAuthorizationStatus authStatus;
@property (nonatomic, strong) UIButton *returnButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *scanFrameView;
@property (nonatomic, strong) UIButton *lightButton;
@property (nonatomic, strong) UIImageView *frameImageView;
@property (nonatomic, strong) UIImageView *gridImageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIView *netUnableView;
@property (nonatomic, strong) UILabel *netUnableLabel;
@property (nonatomic, strong) UILabel *handlingLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger scanSeconds;
@property (nonatomic, assign) BOOL isScanAble;
@property (nonatomic, assign) BOOL isStart;


@end

@implementation DJScanViewController
- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

//    [self initScanning];
//    [self prepareUI];
    [self setUpNavigation];
    
    [self.view addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(kADMobHeight);
    }];
    [self addADMob];
}

#pragma mark - 广告
- (void)addADMob
{
    self.bannerView.adUnitID = kADMob_HomeUnitId;
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
    request.testDevices = @[ kGADSimulatorID ];
    [self.bannerView loadRequest:request];
}

- (GADBannerView *)bannerView
{
    if (!_bannerView) {
        _bannerView = [[GADBannerView alloc] init];
    
    }
    return _bannerView;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _isHandlerResult = NO;

    self.handlingLabel.hidden = YES;
    [self startScanning];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if (_authStatus == AVAuthorizationStatusDenied || _authStatus == AVAuthorizationStatusRestricted) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"No Authorize", nil) message:NSLocalizedString(@"Please go to the settings - Privacy - Camera license", nil) preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Authorize", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

            if([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        [alertController addAction:okAction];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];

        }];
        [alertController addAction:cancelAction];

        [self presentViewController:alertController animated:YES completion:nil];
    }

    _isStart = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_captureSession || _timer) {
        [self stopScanning];
//        [self releasePro];
    }
}

- (void)initScanning{
    _authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if (_authStatus == AVAuthorizationStatusAuthorized || _authStatus == AVAuthorizationStatusNotDetermined) {
        [self initDevice];
    }
}

- (void)counting{
//    if (![JZAFNetworkingUtil checkNetWork]) {
//        _isScanAble = NO;
//        self.netUnableLabel.hidden = NO;
//        self.netUnableView.hidden = NO;
//        [self.gridImageView.layer removeAllAnimations];
//        self.textLabel.alpha = 0.7;
//
//    }
//    else{
        if (!_isScanAble) {
            _isScanAble = YES;
            self.netUnableLabel.hidden = YES;
            self.netUnableView.hidden = YES;
            [self gridAnimation];
            self.textLabel.alpha = 1;
        }
//    }

    if (_scanSeconds++ == 200) {
        self.textLabel.text = NSLocalizedString(@"Please focus on the QRCode, wait patiently", nil);
        [self.textLabel sizeToFit];
        self.textLabel.center = CGPointMake(self.frameImageView.center.x, self.textLabel.center.y);
    }
}

- (void)setUpNavigation
{
    SYTopNaviBarView *topNavi = [[SYTopNaviBarView alloc] init];
    topNavi.titleLabel.text = NSLocalizedString(@"sao yi sao", nil);
    topNavi.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:topNavi];
    [self.view bringSubviewToFront:topNavi];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"album"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"album"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(albumClick) forControlEvents:UIControlEventTouchUpInside];
    [topNavi addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(topNavi);
        make.width.height.mas_equalTo(44);
    }];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:[UIImage imageNamed:@"tab_orderselected"] forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"tab_orderselected"] forState:UIControlStateHighlighted];
    [button1 addTarget:self action:@selector(create) forControlEvents:UIControlEventTouchUpInside];
    [topNavi addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(topNavi);
        make.width.height.mas_equalTo(44);
    }];
}

- (void)create
{
    CreateViewController *vc = [[CreateViewController alloc] init];
    [kRootNavigation pushViewController:vc animated:YES];
}

- (void)prepareUI{
//    [self.view addSubview:self.returnButton];
//    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.frameImageView];
    [self.frameImageView addSubview:self.gridImageView];
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.netUnableView];
    [self.view addSubview:self.netUnableLabel];
    [self.view addSubview:self.lightButton];
    [self.view addSubview:self.handlingLabel];

    [self.lightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.frameImageView.mas_bottom).mas_offset(-10);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
}

- (void)gridAnimation{
    CGPoint originPoint = self.gridImageView.layer.position;

    CABasicAnimation *positionAnimation1 = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation1.toValue = [NSValue valueWithCGPoint:CGPointMake(originPoint.x, originPoint.y + scanWidth)];
    positionAnimation1.duration = 1.3;
    positionAnimation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    CABasicAnimation *positonAnimation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    positonAnimation2.fromValue = [NSValue valueWithCGPoint:CGPointMake(originPoint.x, originPoint.y + scanWidth)];
    positonAnimation2.toValue = [NSValue valueWithCGPoint:CGPointMake(originPoint.x, originPoint.y + scanWidth)];
    positonAnimation2.duration = 0.3;
    positonAnimation2.beginTime = 1.3;

    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 2.0;
    opacityAnimation.values = @[
                                [NSNumber numberWithFloat:0],
                                [NSNumber numberWithFloat:1.0],
                                [NSNumber numberWithFloat:0]
                                ];
    opacityAnimation.keyTimes = @[@(0),@(0.65),@(0.8)];

    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[positionAnimation1,positonAnimation2,opacityAnimation];
    animationGroup.repeatCount = HUGE_VAL;
    animationGroup.duration = 2.0;
    animationGroup.removedOnCompletion = NO;

    [self.gridImageView.layer addAnimation:animationGroup forKey:@"gridAniamtion"];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)returnButton{
    if (!_returnButton) {
        _returnButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 14, 56, 56)];
        [_returnButton setImage:[UIImage imageNamed:@"scanReturn"] forState:UIControlStateNormal];
        [_returnButton setImage:[UIImage imageNamed:@"scanReturnTouched"] forState:UIControlStateHighlighted];
        [_returnButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnButton;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 51, 24)];
        _titleLabel.center = CGPointMake(self.view.center.x, self.returnButton.center.y);
        _titleLabel.text = @"扫一扫";
        [_titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:17]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
    }
    return _titleLabel;
}

- (UIImageView *)frameImageView{
    if (!_frameImageView) {
        _frameImageView = [[UIImageView alloc]initWithFrame:scanRect];
        _frameImageView.image = [UIImage imageNamed:@"scanFrame"];
        _frameImageView.clipsToBounds = YES;
    }
    return _frameImageView;
}

- (UIImageView *)gridImageView{
    if (!_gridImageView) {
        _gridImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -scanWidth, scanWidth, scanWidth)];
        _gridImageView.image = [UIImage imageNamed:@"scanGrid"];
        _gridImageView.alpha = 0;
    }
    return _gridImageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        CGFloat heightRate = 0.66;
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        if (kScreenSize.width == 480) {
            heightRate = 0.75;
            font = [UIFont systemFontOfSize:14];
        }
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenSize.height * heightRate, 200, 16)];
        _textLabel.text = NSLocalizedString(@"The QRCode can be automatically scanned by putting it into the frame", nil);
        [_textLabel setTextColor:[UIColor whiteColor]];
        [_textLabel setFont:font];
        [_textLabel sizeToFit];
        _textLabel.center = CGPointMake(self.frameImageView.center.x, _textLabel.center.y);
    }
    return _textLabel;
}

- (UIView *)netUnableView{
    if (!_netUnableView) {
        _netUnableView = [[UIView alloc]initWithFrame:scanRect];
        _netUnableView.alpha = 0.5;
        _netUnableView.backgroundColor = [UIColor blackColor];
        _netUnableView.hidden = YES;
    }
    return _netUnableView;
}

- (UILabel *)netUnableLabel{
    if (!_netUnableLabel) {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        if (kScreenSize.width == 480) {
            font = [UIFont systemFontOfSize:15];
        }
        _netUnableLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 17)];
        _netUnableLabel.text = @"无法连接网络，请检查网络设置";
        _netUnableLabel.textColor = [UIColor whiteColor];
        [_netUnableLabel setFont:font];
        [_netUnableLabel sizeToFit];
        _netUnableLabel.center = self.frameImageView.center;
        _netUnableLabel.hidden = YES;
    }
    return _netUnableLabel;
}

- (UILabel *)handlingLabel{
    if (!_handlingLabel) {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        if (kScreenSize.width == 480) {
            font = [UIFont systemFontOfSize:15];
        }
        _handlingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 17)];
        _handlingLabel.text = NSLocalizedString(@"handleing..." , nil);
        _handlingLabel.textColor = [UIColor whiteColor];
        [_handlingLabel setFont:font];
        [_handlingLabel sizeToFit];
        _handlingLabel.center = self.frameImageView.center;
        _handlingLabel.hidden = YES;
    }
    return _handlingLabel;
}

- (UIButton *)lightButton{
    if (!_lightButton) {
        CGFloat heightRate = 0.76;
        if (kScreenSize.width == 480) {
            heightRate = 0.82;
        }
        _lightButton = [[UIButton alloc]init];
        _lightButton.tag = 0;
        [_lightButton setImage:[UIImage imageNamed:@"lightSwitchOff"] forState:UIControlStateNormal];
        [_lightButton setImage:[UIImage imageNamed:@"lightSwitchOffTouched"] forState:UIControlStateHighlighted];
        [_lightButton addTarget:self action:@selector(lightSwitch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lightButton;
}

- (void)initDevice{
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    //输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    if ([_captureSession canAddInput:input]) {
        [_captureSession addInput:input];
    }
    //输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    if ([_captureSession canAddOutput:captureMetadataOutput]) {
        [_captureSession addOutput:captureMetadataOutput];
    }

    dispatch_queue_t dispatchQueue = dispatch_queue_create(kScanQRCodeQueueName, NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    //设置元数据类型 AVMetadataObjectTypeQRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];

    //创建输出对象
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.view.layer.bounds];
    [self.view.layer addSublayer:_videoPreviewLayer];

    UIView *maskView = [[UIView alloc]initWithFrame:self.view.frame];
    maskView.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:maskView];

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.view.bounds];
    [path appendPath:[UIBezierPath bezierPathWithRect:scanRect].bezierPathByReversingPath];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    maskView.layer.mask = shapeLayer;

    //设置扫描区域
    captureMetadataOutput.rectOfInterest = CGRectMake(scanRect.origin.y/kScreenSize.height, scanRect.origin.x/kScreenSize.width, scanRect.size.height/kScreenSize.height, scanRect.size.width/kScreenSize.width);
}

- (void)startScanning{
    _scanSeconds = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(counting) userInfo:nil repeats:YES];

    [self gridAnimation];
    [_captureSession startRunning];
}

- (void)stopScanning{
    [_timer invalidate];
    [_captureSession stopRunning];
    [self.gridImageView.layer removeAllAnimations];

//    _timer = nil;
//     _captureSession = nil;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_isScanAble && _isStart) {
            _isScanAble = NO;
            self.handlingLabel.hidden = NO;

            [self stopScanning];
            [self sound];

            if (metadataObjects != nil && [metadataObjects count] > 0) {
                AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
                NSString *result;

                if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
                    result = metadataObj.stringValue;
                } else {
                    NSLog(@"无法识别二维码");
                }

                if (!_isHandlerResult) {
                    _isHandlerResult = YES;
                    [self performSelectorOnMainThread:@selector(handleScanResult:) withObject:result waitUntilDone:NO];
                }
            }
        }
    });
}

- (void)handleScanResult:(NSString *)result{
    if (result.length <= 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"scan result", nil) message:NSLocalizedString(@"Unable to identify QRCode", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"confirm", nil) otherButtonTitles:nil, nil];
        [alertView show];
    }
    
//    if ([result hasPrefix:@"http"]) {
//        [[UIApplication sharedApplication] openURL:url];
//    }else{
        ScanResultViewController *scanResultVC = [[ScanResultViewController alloc] init];
        scanResultVC.result = result;
        [kRootNavigation pushViewController:scanResultVC animated:YES];
//    }
}

- (void)sound{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"aigei_com.mp3" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:soundPath];

    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
    AudioServicesPlayAlertSound(soundID);
}

- (void)lightSwitch{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    if ([device hasTorch]) {

        [device lockForConfiguration:nil];

        if (self.lightButton.tag == 0) {
            self.lightButton.tag = 1;

            [self.lightButton setImage:[UIImage imageNamed:@"lightSwitchOn"] forState:UIControlStateNormal];
            [self.lightButton setImage:[UIImage imageNamed:@"lightSwitchOnTouched"] forState:UIControlStateHighlighted];

            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            self.lightButton.tag = 0;

            [self.lightButton setImage:[UIImage imageNamed:@"lightSwitchOff"] forState:UIControlStateNormal];
            [self.lightButton setImage:[UIImage imageNamed:@"lightSwitchOffTouched"] forState:UIControlStateHighlighted];

            [device setTorchMode:AVCaptureTorchModeOff];
        }

        [device unlockForConfiguration];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)viewName{

    return @"scanOneScan";
}

-(void)setInitParas:(NSDictionary *)dict{

}

//识别图中二维码  选照片
- (void)albumClick
{
//    [[PhotoManager sharedInstance] takePhoto];
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.picker addObserver:self forKeyPath:@"delegate" options:NSKeyValueObservingOptionNew context:nil];
    
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
    
    [self presentViewController:self.picker animated:YES completion:^{
        
    }];
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
            [self reconQrCodeFromImage:image];
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



- (void)reconQrCodeFromImage:(UIImage *)image
{
    if(image){
        //1. 初始化扫描仪，设置设别类型和识别质量
        CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        NSData*imageData =UIImagePNGRepresentation(image);
        CIImage*ciImage = [CIImage imageWithData:imageData];
        NSArray*features = [detector featuresInImage:ciImage];
        if (features.count) {
            CIQRCodeFeature*feature = [features objectAtIndex:0];
            NSString*scannedResult = feature.messageString;
            [self handleScanResult:scannedResult];
        }else{
            [ProgressHUD show:NSLocalizedString(@"Unable to identify QRCode in a graph", nil)];
        }
    }
}
@end
