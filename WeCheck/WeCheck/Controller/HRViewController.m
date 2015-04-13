//
//  HRViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/4/9.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRViewController.h"

@import CoreLocation;
@import CoreBluetooth;

static NSString * const CUUID = @"8AEFB031-6C32-486F-825B-2011A193487D";
static NSString *const CIdentifier = @"CheckIdentifier";

@interface HRViewController ()<CBPeripheralManagerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) CALayer *headLayer;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;

//动画
@property (nonatomic, strong) UIView *viewAnimation;

@end

@implementation HRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - function
- (void)animationShow {
    _viewAnimation = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _viewAnimation.backgroundColor = [UIColor blackColor];
    _viewAnimation.alpha = 1;
    
    UIButton *btnTurnOffCheck = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTurnOffCheck.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-40, [UIScreen mainScreen].bounds.size.height/2-40, 80, 80);
    btnTurnOffCheck.layer.borderWidth = 1;
    btnTurnOffCheck.layer.borderColor = [UIColor whiteColor].CGColor;
    btnTurnOffCheck.layer.cornerRadius = btnTurnOffCheck.frame.size.width/2;
    [btnTurnOffCheck setTitle:@"停止" forState:UIControlStateNormal];
    [btnTurnOffCheck addTarget:self action:@selector(turnOffCheck:) forControlEvents:UIControlEventTouchUpInside];
    [_viewAnimation addSubview:btnTurnOffCheck];
    
    int count = 6;
    float duration = 4.0;
    for (int i = 0; i<count; i++) {
        _headLayer = [CALayer layer];
        _headLayer.borderWidth = 0.6;
        _headLayer.borderColor = [UIColor whiteColor].CGColor;
        _headLayer.frame = CGRectMake(10, 10, 80, 80);
        _headLayer.cornerRadius = _headLayer.frame.size.width/2;
        _headLayer.position = _viewAnimation.center;
        [_viewAnimation.layer addSublayer:_headLayer];
        
        CABasicAnimation *scaleAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation1.fromValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation1.toValue = [NSNumber numberWithFloat:10.0];
        scaleAnimation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"circleShaperLayer"];
        opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        opacityAnimation.toValue = [NSNumber numberWithFloat:0];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.duration = duration;
        animationGroup.autoreverses = NO;   //是否重播，原动画的倒播
        animationGroup.repeatCount = HUGE_VAL;//HUGE_VALF;     //HUGE_VALF,源自math.h
        animationGroup.delegate = self;
        [animationGroup setAnimations:[NSArray arrayWithObjects:opacityAnimation, scaleAnimation1, nil]];
        
        animationGroup.beginTime = CACurrentMediaTime()+i*duration/count;
        [_headLayer addAnimation:animationGroup forKey:nil];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:_viewAnimation];
}
- (IBAction)turnOnCollection:(UIButton *)sender {
//    [self performSegueWithIdentifier:@"checkListSegue" sender:nil];
}

- (IBAction)turnOnCheck:(UIButton *)sender {
    
    if (!_peripheralManager)
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    if (self.peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        NSLog(@"蓝牙关闭");
        return;
    }
    
    [self animationShow];
    
    if ([self checkPeripheralAccess]) {
        time_t t;
        srand((unsigned) time(&t));
        CLBeaconMajorValue maj = 20151.0;
        CLBeaconMinorValue min = 00101.0;
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:CUUID]
                                                                         major:maj
                                                                         minor:min
                                                                    identifier:CIdentifier];
        NSDictionary *beaconPeripheralData = [region peripheralDataWithMeasuredPower:nil];
        [_peripheralManager startAdvertising:beaconPeripheralData];
        
        NSLog(@"开始广播签到: %@.", region);
    }
}
- (void)turnOffCheck:(UIButton *)sender {
    [_viewAnimation removeFromSuperview];
    [_headLayer removeAllAnimations];
    [_peripheralManager stopAdvertising];
}
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheralManager
{
    if (peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        NSLog(@"蓝牙关闭");
        return;
    }
}

- (BOOL)checkPeripheralAccess {
    CBPeripheralManagerAuthorizationStatus authorizationStatus = [CBPeripheralManager authorizationStatus];
    if (authorizationStatus != CBPeripheralManagerAuthorizationStatusAuthorized) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"蓝牙共享"
                                                        message:@"蓝牙共享关闭，点击设置打开。"
                                                       delegate:self
                                              cancelButtonTitle:@"设置"
                                              otherButtonTitles:@"取消", nil];
        [alert show];
        return FALSE;
    }
    return TRUE;
}

#pragma mark - Alert view delegate methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CALayer *layer = [anim valueForKey:@"circleShaperLayer"];
    if (layer) {
        [layer removeFromSuperlayer];
    }
}
@end
