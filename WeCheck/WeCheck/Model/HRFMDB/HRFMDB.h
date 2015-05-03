//
//  HRFMDB.h
//  WeCheck
//
//  Created by HaiRui on 15/4/27.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRFMDB : NSObject

//初始化fmdb对象
+ (instancetype)shareFMDBManager;

/**
 *  @author HaiRui
 *
 *  @brief  创建KeyValue,CheckScene,CheckRecord表
 *
 *  @return YES创建成功
 */
- (BOOL)createTable;

#pragma mark - KeyValue表方法
/**
 *  @author HaiRui
 *
 *  @brief  插入KeyValue键值对
 *
 *  @param value value值
 *  @param key   key值
 *
 *  @return YES创建成功
 */
- (BOOL)setInToKeyValueTable:(id)value
                      forKey:(NSString *)key;
/**
 *  @author HaiRui
 *
 *  @brief  根据KEY查询键值对
 *
 *  @param key key值
 *
 *  @return object
 */
- (id)queryInKeyValueTable:(NSString *)key;

/**
 *  @author HaiRui
 *
 *  @brief  根据key删除KeyValue表中值
 *
 *  @param key key值
 *
 *  @return YES删除成功
 */
- (BOOL)deleteKeyValueTable:(NSString *)key;

#pragma mark - CheckScene表方法
/**
 *  @author HaiRui
 *
 *  @brief  插入people在一个情景中
 *
 *  @param dic people信息 名字和代号
 *  @param key 情景名字
 *
 *  @return YES插入成功
 */
- (BOOL)insertInToCheckSceneTable:(NSDictionary *)dic objectForKey:(NSString *)key;
/**
 *  @author HaiRui
 *
 *  @brief  删除情景中people
 *
 *  @param dic people信息 名字和代号
 *
 *  @return YES删除成功
 */
- (BOOL)deleteCheckSceneTable:(NSDictionary *)dic;
#pragma mark - CheckRecord表方法

@end
