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

@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;

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
- (IBAction)teacherTurnOnCheck:(UIButton *)sender {
    [self performSegueWithIdentifier:@"checkListSegue" sender:nil];
}

- (IBAction)studentTurnOnCheck:(UIButton *)sender {
    if (!_peripheralManager)
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    if (self.peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        NSLog(@"蓝牙关闭");
        return;
    }
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
        [self.peripheralManager startAdvertising:beaconPeripheralData];
        
        NSLog(@"开始广播签到: %@.", region);
    }
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
@end
