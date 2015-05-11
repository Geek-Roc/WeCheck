//
//  HRViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/4/9.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRViewController.h"
#import "UILabel+FlickerNumber.h"
#import "HRFMDB.h"
#import "HRCheckEditViewController.h"
@import CoreLocation;
@import CoreBluetooth;

static NSString * const CUUID = @"8AEFB031-6C32-486F-825B-2011A193487D";
static NSString *const CIdentifier = @"CheckIdentifier";

@interface HRViewController ()<CBPeripheralManagerDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) CALayer *headLayer;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;

@property (nonatomic, strong) CAShapeLayer *layerArc;
@property (nonatomic, strong) UILabel *lbStatisticNumber;
//签到动画
@property (nonatomic, strong) UIView *viewAnimation;
@property (weak, nonatomic) IBOutlet UITableView *tableViewRecentlyStatistic;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) IBOutlet UIButton *btnCollection;
//签到信息
@property (nonatomic, strong) NSDictionary *dicCheckInfo;
@property (nonatomic, strong) NSMutableArray *mutArrScenes;
//情景统计
@property (nonatomic, strong) NSMutableArray *mutArrSceneProbability;
//总体签到率
@property (nonatomic, strong) NSString *stringNumber;
@end

@implementation HRViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self drawLineAnimation:_layerArc forKey:@"123"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSDictionary *dic = [[HRFMDB shareFMDBManager] queryInCheckRecordTableForAllScene];
        _stringNumber = [NSString stringWithFormat:@"%0.4f", [dic[@"0"] floatValue]/([dic[@"0"] floatValue]+[dic[@"1"] floatValue]+[dic[@"2"] floatValue])];
        _dicCheckInfo = [[HRFMDB shareFMDBManager] queryInKeyValueTable:@"HRCheckInfo"];
        _mutArrScenes = [NSMutableArray arrayWithArray:[[HRFMDB shareFMDBManager] queryInKeyValueTable:@"HRCheckSceneList"]];
        _mutArrSceneProbability = [NSMutableArray arrayWithArray:[[HRFMDB shareFMDBManager] queryInCheckRecordTable]];
        for (NSMutableDictionary *mutDic in _mutArrSceneProbability) {
            [mutDic setObject:[[HRFMDB shareFMDBManager] queryInCheckSceneTableNum:mutDic[@"checkScene"]] forKey:@"sceneNumber"];
            NSDictionary *dic = [[HRFMDB shareFMDBManager] queryInCheckRecordTableForEachTime:mutDic[@"checkTime"]];
            [mutDic setObject:[NSString stringWithFormat:@"%0.2f", 100*[dic[@"0"] floatValue]/([dic[@"0"] floatValue]+[dic[@"1"] floatValue]+[dic[@"2"] floatValue])] forKey:@"checkProbability"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_lbStatisticNumber dd_setNumber:@([_stringNumber floatValue]*100) format:@"%@%%" formatter:nil];
            [_tableViewRecentlyStatistic reloadData];
        });
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    ((UITabBarItem *)[self.view viewWithTag:1]).selectedImage = [[UIImage imageNamed:@"check2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_btnCheck setBackgroundImage:[UIImage imageNamed:@"blackbackground"] forState:UIControlStateHighlighted];
    [_btnCollection setBackgroundImage:[UIImage imageNamed:@"blackbackground"] forState:UIControlStateHighlighted];
    //创建数据库
    [[HRFMDB shareFMDBManager] createTable];
    
    
}
//定义动画过程
-(void)drawLineAnimation:(CALayer*)layer forKey:(NSString *)key
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = 1;
    bas.delegate = self;
    bas.fromValue = @0;
    bas.toValue = @1;
    [layer addAnimation:bas forKey:key];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[HRCheckEditViewController class]]) {
        HRCheckEditViewController *hrcevc = segue.destinationViewController;
        hrcevc.dicScene = sender;
    }
}

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
- (IBAction)btnTurnOnCollectAction:(UIButton *)sender {
    if (_mutArrScenes.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未设置情景信息" message:@"第一次使用请点击右上角+号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [self performSegueWithIdentifier:@"CheckListSegue" sender:nil];
}

- (IBAction)turnOnCheck:(UIButton *)sender {
    if (!_dicCheckInfo) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未设置签到信息" message:@"请在'我'右上角添加设置！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (!_peripheralManager)
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    if (_peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未开蓝牙" message:@"请打开蓝牙！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [self animationShow];
    
    if ([self checkPeripheralAccess]) {
        time_t t;
        srand((unsigned) time(&t));
        CLBeaconMajorValue maj = [[_dicCheckInfo[@"HRCheckInfoNumber"] substringToIndex:5] intValue];
        CLBeaconMinorValue min = [[_dicCheckInfo[@"HRCheckInfoNumber"] substringFromIndex:5] intValue];
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
- (BOOL)checkPeripheralAccess {
    CBPeripheralManagerAuthorizationStatus authorizationStatus = [CBPeripheralManager authorizationStatus];
    if (authorizationStatus != CBPeripheralManagerAuthorizationStatusAuthorized) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"蓝牙共享"
                                                        message:@"蓝牙共享关闭，点击设置打开。"
                                                       delegate:self
                                              cancelButtonTitle:@"设置"
                                              otherButtonTitles:@"取消", nil];
        alert.tag = 100;
        [alert show];
        return FALSE;
    }
    return TRUE;
}
#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheralManager
{
    if (peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未开蓝牙" message:@"请打开蓝牙！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
}
#pragma mark - UITableViewDataSource
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[HRFMDB shareFMDBManager] deleteCheckRecordTable:_mutArrSceneProbability[indexPath.row]];
    [_mutArrSceneProbability removeObjectAtIndex:indexPath.row];
    [_tableViewRecentlyStatistic deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSDictionary *dic = [[HRFMDB shareFMDBManager] queryInCheckRecordTableForAllScene];
        _stringNumber = [NSString stringWithFormat:@"%0.4f", [dic[@"0"] floatValue]/([dic[@"0"] floatValue]+[dic[@"1"] floatValue]+[dic[@"2"] floatValue])];
        _dicCheckInfo = [[HRFMDB shareFMDBManager] queryInKeyValueTable:@"HRCheckInfo"];
        _mutArrScenes = [NSMutableArray arrayWithArray:[[HRFMDB shareFMDBManager] queryInKeyValueTable:@"HRCheckSceneList"]];
        _mutArrSceneProbability = [NSMutableArray arrayWithArray:[[HRFMDB shareFMDBManager] queryInCheckRecordTable]];
        for (NSMutableDictionary *mutDic in _mutArrSceneProbability) {
            [mutDic setObject:[[HRFMDB shareFMDBManager] queryInCheckSceneTableNum:mutDic[@"checkScene"]] forKey:@"sceneNumber"];
            NSDictionary *dic = [[HRFMDB shareFMDBManager] queryInCheckRecordTableForEachTime:mutDic[@"checkTime"]];
            [mutDic setObject:[NSString stringWithFormat:@"%0.2f", 100*[dic[@"0"] floatValue]/([dic[@"0"] floatValue]+[dic[@"1"] floatValue]+[dic[@"2"] floatValue])] forKey:@"checkProbability"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_lbStatisticNumber dd_setNumber:@([_stringNumber floatValue]*100) format:@"%@%%" formatter:nil];
            [_tableViewRecentlyStatistic reloadData];
        });
    });
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mutArrSceneProbability.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentlyCheckRecordsCell" forIndexPath:indexPath];
    ((UILabel *)[cell viewWithTag:1001]).text = _mutArrSceneProbability[indexPath.row][@"checkScene"];
    ((UILabel *)[cell viewWithTag:1002]).text = [NSString stringWithFormat:@"签到率：%@%%",_mutArrSceneProbability[indexPath.row][@"checkProbability"]];
    ((UILabel *)[cell viewWithTag:1003]).text = [NSString stringWithFormat:@"总人数：%@人", _mutArrSceneProbability[indexPath.row][@"sceneNumber"]];
    ((UILabel *)[cell viewWithTag:1004]).text = [_mutArrSceneProbability[indexPath.row][@"checkTime"] substringToIndex:10];
    return cell;
}
#pragma mark - UITableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewStatistics = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    viewStatistics.backgroundColor = [UIColor whiteColor];
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, 40)
                                                        radius:35
                                                    startAngle:M_PI_2
                                                      endAngle:M_PI_2+M_PI*2*[_stringNumber floatValue]
                                                     clockwise:YES];
    _layerArc = [CAShapeLayer layer];
    _layerArc.path=path.CGPath;
    _layerArc.fillColor = [UIColor clearColor].CGColor;
    _layerArc.strokeColor=[UIColor blueColor].CGColor;
    _layerArc.lineWidth = 5;
    [viewStatistics.layer addSublayer:_layerArc];
    
    _lbStatisticNumber = [[UILabel alloc] initWithFrame:CGRectMake(viewStatistics.center.x, viewStatistics.center.y, 60, 21)];
    _lbStatisticNumber.center = viewStatistics.center;
    _lbStatisticNumber.text = [NSString stringWithFormat:@"%0.2f%%", [_stringNumber floatValue]*100];
    _lbStatisticNumber.textAlignment = NSTextAlignmentCenter;
    _lbStatisticNumber.font = [UIFont systemFontOfSize:17];
    [viewStatistics addSubview:_lbStatisticNumber];
    return viewStatistics;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"CheckRecordEditSegue" sender:_mutArrSceneProbability[indexPath.row]];
}
#pragma mark - Alert view delegate methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && alertView.tag == 100) {
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
