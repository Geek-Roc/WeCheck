//
//  HRCheckListViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/4/9.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRCheckListViewController.h"
@import CoreLocation;

static NSString * const CUUID = @"8AEFB031-6C32-486F-825B-2011A193487D";
static NSString *const CIdentifier = @"CheckIdentifier";

static void * const kMonitoringOperationContext = (void *)&kMonitoringOperationContext;
static void * const kRangingOperationContext = (void *)&kRangingOperationContext;

@interface HRCheckListViewController ()<CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UICollectionView *beaconsTableView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@property (nonatomic, unsafe_unretained) void *operationContext;
@property (nonatomic, strong) NSArray *findBeacons;

@end

@implementation HRCheckListViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    // Do any additional setup after loading the view.
//    if (!_locationManager) {
//        _locationManager = [[CLLocationManager alloc] init];
//        _locationManager.delegate = self;
//    }
//    [self checkLocationAccess];
//    
//    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:CUUID];
//    if (!_beaconRegion)
//        _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:CIdentifier];
//    _beaconRegion.notifyEntryStateOnDisplay = YES;
//    
//    [_locationManager startMonitoringForRegion:_beaconRegion];
//    [_locationManager startRangingBeaconsInRegion:_beaconRegion];
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
- (void)checkLocationAccess {
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        if (authorizationStatus == kCLAuthorizationStatusDenied ||
            authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务关闭"
                                                            message:@"定位服务（始终）关闭，点击设置打开。"
                                                           delegate:self
                                                  cancelButtonTitle:@"设置"
                                                  otherButtonTitles:@"取消", nil];
            [alert show];
            return;
        }
        [_locationManager requestAlwaysAuthorization];
    }
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}
//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FindCheckCell" forIndexPath:indexPath];
    [((UIImageView *)[cell viewWithTag:1001]) setImage:[UIImage imageNamed:@"head.jpg"]];
    ((UIImageView *)[cell viewWithTag:1001]).layer.cornerRadius = 35;
    ((UIImageView *)[cell viewWithTag:1001]).clipsToBounds = YES;
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}
//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 0, 0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = {[UIScreen mainScreen].bounds.size.width, 44};
    return size;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCell" forIndexPath:indexPath];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.frame = (CGRect){(CGPoint){210, 12}, indicatorView.frame.size};
    [indicatorView startAnimating];
    [headerView addSubview:indicatorView];
    return headerView;
}
#pragma mark - Location manager delegate methods
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (![CLLocationManager locationServicesEnabled]) {
        if (_operationContext == kMonitoringOperationContext) {
            NSLog(@"Couldn't turn on monitoring: Location services are not enabled.");
            return;
        } else {
            NSLog(@"Couldn't turn on ranging: Location services are not enabled.");
            return;
        }
    }
    
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    switch (authorizationStatus) {
        case kCLAuthorizationStatusAuthorizedAlways:
            if (_operationContext == kMonitoringOperationContext) {
            } else {
            }
            return;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            if (_operationContext == kMonitoringOperationContext) {
                NSLog(@"Couldn't turn on monitoring: Required Location Access(Always) missing.");
            } else {
            }
            return;
            
        default:
            if (_operationContext == kMonitoringOperationContext) {
                NSLog(@"Couldn't turn on monitoring: Required Location Access(Always) missing.");
                return;
            } else {
                NSLog(@"Couldn't turn on monitoring: Required Location Access(WhenInUse) missing.");
                return;
            }
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    NSArray *filteredBeacons = [self filteredBeacons:beacons];
    if (filteredBeacons.count == 0) {
                NSLog(@"No beacons found nearby.");
    } else {
                NSLog(@"Found %lu %@.", (unsigned long)[filteredBeacons count],
                        [filteredBeacons count] > 1 ? @"beacons" : @"beacon");
    }
    _findBeacons = filteredBeacons;
    
    [_beaconsTableView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"进入找到: %@",region);
    NSLog(@"Entered region: %@", region);
    
    [self sendLocalNotificationForBeaconRegion:(CLBeaconRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"Exited region: %@", region);
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSString *stateString = nil;
    switch (state) {
        case CLRegionStateInside:
            stateString = @"inside";
            break;
        case CLRegionStateOutside:
            stateString = @"outside";
            break;
        case CLRegionStateUnknown:
            stateString = @"unknown";
            break;
    }
    NSLog(@"State changed to %@ for region %@.", stateString, region);
}

#pragma mark - Local notifications
- (void)sendLocalNotificationForBeaconRegion:(CLBeaconRegion *)region
{
    UILocalNotification *notification = [UILocalNotification new];
    
    // Notification details
    notification.alertBody = [NSString stringWithFormat:@"Entered beacon region for UUID: %@",
                              region.proximityUUID.UUIDString];   // Major and minor are not available at the monitoring stage
    notification.alertAction = NSLocalizedString(@"View Details", nil);
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

#pragma mark - Index path management
- (NSArray *)filteredBeacons:(NSArray *)beacons
{
    // Filters duplicate beacons out; this may happen temporarily if the originating device changes its Bluetooth id
    NSMutableArray *mutableBeacons = [beacons mutableCopy];
    
    NSMutableSet *lookup = [[NSMutableSet alloc] init];
    for (int index = 0; index < [beacons count]; index++) {
        CLBeacon *curr = [beacons objectAtIndex:index];
        NSString *identifier = [NSString stringWithFormat:@"%@/%@", curr.major, curr.minor];
        
        // this is very fast constant time lookup in a hash table
        if ([lookup containsObject:identifier]) {
            [mutableBeacons removeObjectAtIndex:index];
        } else {
            [lookup addObject:identifier];
        }
    }
    
    return [mutableBeacons copy];
}

@end
