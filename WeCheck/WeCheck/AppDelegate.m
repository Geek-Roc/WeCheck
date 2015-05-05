//
//  AppDelegate.m
//  WeCheck
//
//  Created by HaiRui on 15/3/9.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "DHxlsReader.h"
#import "HRFMDB.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AVOSCloud setApplicationId:@"7c3s5yy5j7n588zw9i2bt1s6hnu7xjblbmfyz3fk1f02m8ts"
                      clientKey:@"drotny2cmbnkt0tauxkfx3x4zy88la6n7762h923ljvp9k5s"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    /*外部文件访问本应用,会传递参数过来*/
    NSLog(@"application = %@",application);
    NSLog(@"url = %@",url);
    NSLog(@"sourceApplication = %@",sourceApplication);
    NSLog(@"annotation = %@",annotation);
    
    
    NSString *path = [url.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""];

    DHxlsReader *reader = [DHxlsReader xlsReaderWithPath:path];
    assert(reader);
    [reader startIterator:0];
    
    NSMutableArray *mutArrXlsInfo = [NSMutableArray array];
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    while(YES) {
        DHcell *cell = [reader nextCell];
        if(cell.type == cellBlank) break;
        if (cell.row == 1 && [[cell colString] isEqualToString:@"A"]) {
            if (![cell.str isEqualToString:@"代号"]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"xls格式不正确" message:@"第一列放代号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                break;
            }
        }else if (cell.row == 1 && [[cell colString] isEqualToString:@"B"]) {
            if (![cell.str isEqualToString:@"名字"]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"xls格式不正确" message:@"第二列放名字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                break;
            }
        }else if (cell.row == 1 && [[cell colString] isEqualToString:@"C"]) {
            if (![cell.str isEqualToString:@"情景"]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"xls格式不正确" message:@"第三列放情景" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                break;
            }
        }
        
        if ([[cell colString] isEqualToString:@"A"]) {
            if (cell.str.length > 11)
                [mutDic setObject:[cell.str substringToIndex:10] forKey:@"peopleNumber"];
            else
                [mutDic setObject:cell.str forKey:@"peopleNumber"];
        }
        else if ([[cell colString] isEqualToString:@"B"])
            [mutDic setObject:cell.str forKey:@"peopleName"];
        else if ([[cell colString] isEqualToString:@"C"]) {
            [mutDic setObject:cell.str forKey:@"checkScene"];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:mutDic];
            [mutArrXlsInfo addObject:dic];
        }
    }
    [self importFromXls:mutArrXlsInfo];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - function
- (void)importFromXls:(NSMutableArray *)array {
    [array removeObjectAtIndex:0];
    for (NSDictionary *dic in array) {
        NSDictionary *dicScene = @{@"checkScene":dic[@"checkScene"],
                                   @"checkNumber":@"0"};
        NSMutableArray *mutArr = [NSMutableArray arrayWithArray:[[HRFMDB shareFMDBManager] queryInKeyValueTable:@"HRCheckSceneList"]];
        if (![mutArr containsObject:dicScene]) {
            [mutArr insertObject:dicScene atIndex:0];
            [[HRFMDB shareFMDBManager] setInToKeyValueTable:mutArr forKey:@"HRCheckSceneList"];
        }
        NSDictionary *dicPeople = @{@"peopleName":dic[@"peopleName"],
                                    @"peopleNumber":dic[@"peopleNumber"]};
        [[HRFMDB shareFMDBManager] insertInToCheckSceneTable:dicPeople objectForKey:dic[@"checkScene"]];
        
    }
}
@end
