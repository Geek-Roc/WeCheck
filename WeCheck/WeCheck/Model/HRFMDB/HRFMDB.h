//
//  HRFMDB.h
//  WeCheck
//
//  Created by HaiRui on 15/4/27.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRFMDB : NSObject
@property (nonatomic, strong) NSString *defaultTableName;

//初始化fmdb对象
+ (instancetype)shareFMDBManager;

//创建表
- (BOOL)createTable:(NSString *)tableName;

//添加人员信息
- (BOOL)insertInToTableName:(NSString *)tablename
             withParameters:(NSDictionary *)parameters;

//根据ID查询数据
- (NSMutableArray *)queryInTableName:(NSString *)tablename withID:(NSInteger )myID;
//根据姓名查询数据
- (NSMutableArray *)queryInTableName:(NSString *)tablename withName:(NSString *)myName;
//查询全部数据
- (NSMutableArray *)queryInTableNameAll:(NSString *)tablename;

//根据ID删除数据
- (BOOL)deleteTableData:(NSString *)tablename withID:(NSInteger )myID;
//删除所有数据
- (BOOL)deleteTableAllData:(NSString *)tablename;
//删除指定表
- (BOOL)dropTable:(NSString *)tablename;

//默认tableName方法
//创建表
- (BOOL)createTable;

//添加人员信息
- (BOOL)insertWithParameters:(NSDictionary *)parameters;

//根据ID查询数据
- (NSMutableArray *)queryWithID:(NSInteger )myID;
//根据姓名查询数据
- (NSMutableArray *)queryWithName:(NSString *)myName;
//查询全部数据
- (NSMutableArray *)queryAll;

//根据ID删除数据
- (BOOL)deleteDataWithID:(NSInteger )myID;
//删除所有数据
- (BOOL)deleteAllData;
//删除默认表
- (BOOL)dropTable;
@end
