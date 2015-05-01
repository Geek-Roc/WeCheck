//
//  HRFMDB.m
//  WeCheck
//
//  Created by HaiRui on 15/4/27.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRFMDB.h"
#import "FMDB.h"

@interface HRFMDB ()
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation HRFMDB
//初始化fmdb对象
+ (instancetype)shareFMDBManager{
    return [[self alloc] init];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentDirectory = [paths objectAtIndex:0];
        //dbPath： 数据库路径，在Document中。
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"wecheck.db"];
        NSLog(@"数据库路径：%@", dbPath);
        _db = [FMDatabase databaseWithPath:dbPath];
    }
    return self;
}

- (BOOL)createKeyValueTable {
    if ([_db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS KeyValue (KEY TEXT PRIMARY KEY NOT NULL, VALUE TEXT NOT NULL)"];
        BOOL res = [_db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"建表失败");
            return NO;
        } else {
            NSLog(@"建表成功");
        }
        [_db close];
    }
    return YES;
}
//创建表
- (BOOL) createTable:(NSString *)tableName{
    if ([_db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,HEADIMG BLOB,NAME TEXT,GENDER TEXT,AGE TEXT,NATION TEXT,NATIVEPLA TEXT,ISMARRIED TEXT,PHONENUM TEXT,QQNUM TEXT,EMAILADDR TEXT,COMPANYNAME TEXT,COMPANYADDR TEXT)",tableName];
        BOOL res = [_db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
            return NO;
        } else {
            NSLog(@"success to creating db table");
        }
        [_db close];
    }
    return YES;
}
- (BOOL)insertInToKeyValueTable:(NSString *)key
                      withValue:(id)value {
    NSError * error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:value options:0 error:&error];
    if (error) {
        NSLog(@"转化json data失败");
        return NO;
    }
    NSString * jsonString = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"REPLACE INTO KeyValue (KEY, VALUE) VALUES (?, ?)"];
        BOOL res = [_db executeUpdate:sql,key,jsonString];
        if (!res) {
            NSLog(@"插入KeyValue失败");
            return NO;
        } else {
            NSLog(@"插入KeyValue成功");
        }
        [_db close];
    }
    return YES;
}
- (id)queryInKeyValueTable:(NSString *)key {
    NSMutableArray *peopleArr = [NSMutableArray array];
    NSString *json;
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT KEY, VALUE FROM KeyValue WHERE KEY = '%@'", key];
        FMResultSet * rs = [_db executeQuery:sql];
        if ([rs next]) {
            json = [rs stringForColumn:@"VALUE"];
        }
        [_db close];
    }
    if (json) {
        NSError * error;
        id result = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            NSLog(@"转化JSON失败");
            return nil;
        }
        peopleArr = result;
    }
    return peopleArr;
}
//添加人员信息
- (BOOL)insertInToTableName:(NSString *)tablename
             withParameters:(NSDictionary *)parameters{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (HEADIMG, NAME, GENDER, AGE, NATION, NATIVEPLA, ISMARRIED, PHONENUM, QQNUM, EMAILADDR, COMPANYNAME, COMPANYADDR) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                         tablename];
        BOOL res = [_db executeUpdate:sql,
                    [parameters objectForKey:@"headImg"],
                    [parameters objectForKey:@"name"],
                    [parameters objectForKey:@"gender"],
                    [parameters objectForKey:@"age"],
                    [parameters objectForKey:@"nation"],
                    [parameters objectForKey:@"nativePla"],
                    [parameters objectForKey:@"isMarried"],
                    [parameters objectForKey:@"phoneNum"],
                    [parameters objectForKey:@"qqNum"],
                    [parameters objectForKey:@"emailAddr"],
                    [parameters objectForKey:@"companyName"],
                    [parameters objectForKey:@"companyAddr"]];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        [_db close];
    }
    return YES;
}
//根据ID查询数据
- (NSMutableArray *)queryInTableName:(NSString *)tablename withID:(NSInteger )myID{
    NSMutableArray *peopleArr = [NSMutableArray array];
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE ID = %ld",tablename,myID];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *peopleDic = [NSMutableDictionary dictionary];
            [peopleDic setObject:[rs stringForColumn:@"ID"] forKey:@"id"];
            [peopleDic setObject:[rs dataForColumn:@"HEADIMG"] forKey:@"headImg"];
            [peopleDic setObject:[rs stringForColumn:@"NAME"] forKey:@"name"];
            [peopleDic setObject:[rs stringForColumn:@"GENDER"] forKey:@"gender"];
            [peopleDic setObject:[rs stringForColumn:@"AGE"] forKey:@"age"];
            [peopleDic setObject:[rs stringForColumn:@"NATION"] forKey:@"nation"];
            [peopleDic setObject:[rs stringForColumn:@"NATIVEPLA"] forKey:@"nativePla"];
            [peopleDic setObject:[rs stringForColumn:@"ISMARRIED"] forKey:@"isMarried"];
            [peopleDic setObject:[rs stringForColumn:@"PHONENUM"] forKey:@"phoneNum"];
            [peopleDic setObject:[rs stringForColumn:@"QQNUM"] forKey:@"qqNum"];
            [peopleDic setObject:[rs stringForColumn:@"EMAILADDR"] forKey:@"emailAddr"];
            [peopleDic setObject:[rs stringForColumn:@"COMPANYNAME"] forKey:@"companyName"];
            [peopleDic setObject:[rs stringForColumn:@"COMPANYADDR"] forKey:@"companyAddr"];
            [peopleArr addObject:peopleDic];
        }
        [_db close];
    }
    return peopleArr;
}
//根据名字查询数据
- (NSMutableArray *)queryInTableName:(NSString *)tablename withName:(NSString *)myName{
    NSMutableArray *peopleArr = [NSMutableArray array];
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE NAME = %@",tablename,myName];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *peopleDic = [NSMutableDictionary dictionary];
            [peopleDic setObject:[rs stringForColumn:@"ID"] forKey:@"id"];
            [peopleDic setObject:[rs dataForColumn:@"HEADIMG"] forKey:@"headImg"];
            [peopleDic setObject:[rs stringForColumn:@"NAME"] forKey:@"name"];
            [peopleDic setObject:[rs stringForColumn:@"GENDER"] forKey:@"gender"];
            [peopleDic setObject:[rs stringForColumn:@"AGE"] forKey:@"age"];
            [peopleDic setObject:[rs stringForColumn:@"NATION"] forKey:@"nation"];
            [peopleDic setObject:[rs stringForColumn:@"NATIVEPLA"] forKey:@"nativePla"];
            [peopleDic setObject:[rs stringForColumn:@"ISMARRIED"] forKey:@"isMarried"];
            [peopleDic setObject:[rs stringForColumn:@"PHONENUM"] forKey:@"phoneNum"];
            [peopleDic setObject:[rs stringForColumn:@"QQNUM"] forKey:@"qqNum"];
            [peopleDic setObject:[rs stringForColumn:@"EMAILADDR"] forKey:@"emailAddr"];
            [peopleDic setObject:[rs stringForColumn:@"COMPANYNAME"] forKey:@"companyName"];
            [peopleDic setObject:[rs stringForColumn:@"COMPANYADDR"] forKey:@"companyAddr"];
            [peopleArr addObject:peopleDic];
        }
        [_db close];
    }
    return peopleArr;
}
//查询全部数据
- (NSMutableArray *)queryInTableNameAll:(NSString *)tablename{
    NSMutableArray *peopleArr = [NSMutableArray array];
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@",tablename];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *peopleDic = [NSMutableDictionary dictionary];
            [peopleDic setObject:[rs stringForColumn:@"ID"] forKey:@"id"];
            [peopleDic setObject:[rs dataForColumn:@"HEADIMG"] forKey:@"headImg"];
            [peopleDic setObject:[rs stringForColumn:@"NAME"] forKey:@"name"];
            [peopleDic setObject:[rs stringForColumn:@"GENDER"] forKey:@"gender"];
            [peopleDic setObject:[rs stringForColumn:@"AGE"] forKey:@"age"];
            [peopleDic setObject:[rs stringForColumn:@"NATION"] forKey:@"nation"];
            [peopleDic setObject:[rs stringForColumn:@"NATIVEPLA"] forKey:@"nativePla"];
            [peopleDic setObject:[rs stringForColumn:@"ISMARRIED"] forKey:@"isMarried"];
            [peopleDic setObject:[rs stringForColumn:@"PHONENUM"] forKey:@"phoneNum"];
            [peopleDic setObject:[rs stringForColumn:@"QQNUM"] forKey:@"qqNum"];
            [peopleDic setObject:[rs stringForColumn:@"EMAILADDR"] forKey:@"emailAddr"];
            [peopleDic setObject:[rs stringForColumn:@"COMPANYNAME"] forKey:@"companyName"];
            [peopleDic setObject:[rs stringForColumn:@"COMPANYADDR"] forKey:@"companyAddr"];
            [peopleArr addObject:peopleDic];
        }
        [_db close];
    }
    return peopleArr;
}
//根据ID删除数据
- (BOOL)deleteTableData:(NSString *)tablename withID:(NSInteger )myID{
    if ([_db open]) {
        
        NSString *deleteSql = [NSString stringWithFormat:
                               @"DELETE from %@ WHERE 1 = 1",
                               tablename];
        BOOL res = [_db executeUpdate:deleteSql];
        
        if (!res) {
            NSLog(@"删除ID:%ld出错",myID);
        } else {
            NSLog(@"删除ID:%ld成功",myID);
        }
        [_db close];
    }
    return YES;
}
//删除所有数据
- (BOOL)deleteTableAllData:(NSString *)tablename{
    if ([_db open]) {
        
        NSString *deleteSql = [NSString stringWithFormat:
                               @"DELETE from %@ WHERE 1 = 1",
                               tablename];
        BOOL res = [_db executeUpdate:deleteSql];
        
        if (!res) {
            NSLog(@"删除所有数据出错");
        } else {
            NSLog(@"删除所有数据成功");
        }
        [_db close];
    }
    return YES;
}
//删除指定表
- (BOOL)dropTable:(NSString *)tablename{
    if ([_db open]) {
        
        NSString *deleteSql = [NSString stringWithFormat:
                               @"DROP TABLE %@",
                               tablename];
        BOOL res = [_db executeUpdate:deleteSql];
        
        if (!res) {
            NSLog(@"删除所有数据出错");
        } else {
            NSLog(@"删除所有数据成功");
        }
        [_db close];
    }
    return YES;
}
@end
