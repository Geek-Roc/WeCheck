//
//  HRMeViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/4/21.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRMeViewController.h"
#import <AFNetworking.h>
@interface HRMeViewController ()

@end

@implementation HRMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AFHTTPRequestOperationManager *manager;
    manager = [AFHTTPRequestOperationManager manager];
    NSString *URLString = @"https://openapi.kuaipan.cn/open/requestToken?oauth_signature=NGq7h7qdYh1h6kU3q6cJP2oulBs%3D&oauth_consumer_key=xcgpXocsHXJWhLDh&oauth_nonce=10Tqlb1I&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1429604199&oauth_version=1.0";
    [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    // Do any additional setup after loading the view.
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

@end
