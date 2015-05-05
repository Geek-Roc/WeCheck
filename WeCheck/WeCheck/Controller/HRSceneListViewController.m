//
//  HRSceneListViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/4/23.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRSceneListViewController.h"
#import "HRSceneStatisticViewController.h"
#import "HRFMDB.h"
@interface HRSceneListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *mutArrScenes;
@end

@implementation HRSceneListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mutArrScenes = [[HRFMDB shareFMDBManager] queryInCheckRecordTableForEachScene];
    _mutArrScenes = [[HRFMDB shareFMDBManager] queryInCheckRecordTableForEachSceneDetail:_mutArrScenes];
    for (NSMutableDictionary *mutDic in _mutArrScenes) {
        [mutDic setObject:[[HRFMDB shareFMDBManager] queryInCheckSceneTableNum:mutDic[@"checkScene"]] forKey:@"sceneNumber"];
        [mutDic setObject:[NSString stringWithFormat:@"%0.2f", 100*[mutDic[@"0"] floatValue]/([mutDic[@"0"] floatValue]+[mutDic[@"1"] floatValue]+[mutDic[@"2"] floatValue])] forKey:@"checkProbability"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[HRSceneStatisticViewController class]]) {
        HRSceneStatisticViewController *hrssvc = segue.destinationViewController;
        hrssvc.dicScene = sender;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mutArrScenes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SceneCell" forIndexPath:indexPath];
    ((UILabel *)[cell viewWithTag:1001]).text = _mutArrScenes[indexPath.row][@"checkScene"];
    ((UILabel *)[cell viewWithTag:1002]).text = [NSString stringWithFormat:@"签到率：%@%%",_mutArrScenes[indexPath.row][@"checkProbability"]];
    ((UILabel *)[cell viewWithTag:1003]).text = [NSString stringWithFormat:@"总人数：%@人", _mutArrScenes[indexPath.row][@"sceneNumber"]];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"SceneStatisticSegue" sender:_mutArrScenes[indexPath.row]];
}
@end
