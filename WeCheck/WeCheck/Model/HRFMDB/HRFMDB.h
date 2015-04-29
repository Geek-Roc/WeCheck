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
 *  @brief  创建KeyValue表
 *
 *  @return YES创建成功
 */
- (BOOL)createKeyValueTable;
- (BOOL)createTable:(NSString *)tableName;

/**
 *  @author HaiRui
 *
 *  @brief  插入KeyValue键值对
 *
 *  @param key   key值
 *  @param value value值
 *
 *  @return YES创建成功
 */
- (BOOL)insertInToKeyValueTable:(NSString *)key
                      withValue:(id)value;
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
//添加人员信息
- (BOOL)insertInToTableName:(NSString *)tablename
             withParameters:(NSDictionary *)parameters;

//根据ID查询数据
- (NSMutableArray *)queryInTableName:(NSString *)tablename withID:(NSInteger )myID;
//根据名字查询数据
- (NSMutableArray *)queryInTableName:(NSString *)tablename withName:(NSString *)myName;
//查询全部数据
- (NSMutableArray *)queryInTableNameAll:(NSString *)tablename;

//根据ID删除数据
- (BOOL)deleteTableData:(NSString *)tablename withID:(NSInteger )myID;
//删除所有数据
- (BOOL)deleteTableAllData:(NSString *)tablename;
//删除指定表
- (BOOL)dropTable:(NSString *)tablename;

@end
