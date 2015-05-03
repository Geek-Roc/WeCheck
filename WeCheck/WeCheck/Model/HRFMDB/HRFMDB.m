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
//        NSLog(@"数据库路径：%@", dbPath);
        _db = [FMDatabase databaseWithPath:dbPath];
    }
    return self;
}

- (BOOL)createTable {
    if ([_db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS KeyValue (KEY TEXT PRIMARY KEY NOT NULL, VALUE TEXT NOT NULL)"];
        NSString *sqlCreateTable1 =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CheckScene (CHECKSCENE TEXT PRIMARY KEY NOT NULL, PEOPLENAME PRIMARY KEY TEXT NOT NULL, PEOPLENUMBER PRIMARY KEY TEXT NOT NULL)"];
        NSString *sqlCreateTable2 =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CheckRecord (CHECKSCENE TEXT NOT NULL, PEOPLENAME TEXT NOT NULL, PEOPLENUMBER TEXT NOT NULL, PEOPLESTATE TEXT NOT NULL, CHECKTIME TEXT NOT NULL)"];
        BOOL res = [_db executeUpdate:sqlCreateTable];
        BOOL res1 = [_db executeUpdate:sqlCreateTable1];
        BOOL res2 = [_db executeUpdate:sqlCreateTable2];
        if (!res) {
            NSLog(@"建表KeyValue失败");
            return NO;
        } else {
            NSLog(@"建表KeyValue成功");
        }
        if (!res1) {
            NSLog(@"建表CheckScene失败");
            return NO;
        } else {
            NSLog(@"建表CheckScene成功");
        }
        if (!res2) {
            NSLog(@"建表CheckRecord失败");
            return NO;
        } else {
            NSLog(@"建表CheckRecord成功");
        }
        [_db close];
    }
    return YES;
}

- (BOOL)setInToKeyValueTable:(id)value
                      forKey:(NSString *)key {
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
- (BOOL)deleteKeyValueTable:(NSString *)key{
    if ([_db open]) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE from KeyValue WHERE KEY = '%@'", key];
        BOOL res = [_db executeUpdate:deleteSql];
        if (!res) {
            NSLog(@"删除KeyValue:%@出错", key);
        } else {
            NSLog(@"删除KeyValue:%@成功", key);
        }
        [_db close];
    }
    return YES;
}
- (BOOL)insertInToCheckSceneTable:(NSDictionary *)dic objectForKey:(NSString *)key {
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"INSERT OR IGNORE INTO CheckScene (CHECKSCENE, PEOPLENAME, PEOPLENUMBER) VALUES (?, ?, ?)"];
        BOOL res = [_db executeUpdate:sql,key,dic[@"peopleName"],dic[@"peopleNumber"]];
        if (!res) {
            NSLog(@"插入CheckScene失败");
            return NO;
        } else {
            NSLog(@"插入CheckScene成功");
        }
        [_db close];
    }
    return YES;
}
- (NSString *)queryInCheckSceneTableNum:(NSString *)key {
    NSString *num;
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT count(*) FROM CheckScene WHERE CHECKSCENE = '%@'", key];
        FMResultSet *rs = [_db executeQuery:sql];
        if ([rs next]) {
            num = [NSString stringWithFormat:@"%d", [rs intForColumn:@"count(*)"]];
        }
        [_db close];
    }
    return num;
}
- (id)queryInCheckSceneTable:(NSString *)key {
    NSMutableArray *peopleArr = [NSMutableArray array];
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM CheckScene WHERE CHECKSCENE = '%@'", key];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *dicPeople = [NSMutableDictionary dictionary];
            [dicPeople setObject:[rs stringForColumn:@"PEOPLENAME"] forKey:@"peopleName"];
            [dicPeople setObject:[rs stringForColumn:@"PEOPLENUMBER"] forKey:@"peopleNumber"];
            [peopleArr addObject:dicPeople];
        }
        [_db close];
    }
    return peopleArr;
}
- (BOOL)updateCheckSceneTable:(NSDictionary *)dicNew withOld:(NSDictionary *)dicOld {
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE CheckScene SET PEOPLENAME = '%@', PEOPLENUMBER = '%@' WHERE CHECKSCENE = '%@' AND PEOPLENAME = '%@' AND PEOPLENUMBER = '%@'", dicNew[@"peopleName"], dicNew[@"peopleNumber"], dicOld[@"sceneName"], dicOld[@"peopleName"], dicOld[@"peopleNumber"]];
        BOOL res = [_db executeUpdate:sql];
        if (!res) {
            NSLog(@"修改CheckScene失败");
            return NO;
        } else {
            NSLog(@"修改CheckScene成功");
        }
        [_db close];
    }
    return YES;
}
- (BOOL)deleteCheckSceneTable:(NSDictionary *)dic {
    if ([_db open]) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE from CheckScene WHERE CHECKSCENE = '%@' AND PEOPLENAME = '%@' AND PEOPLENUMBER = '%@'", dic[@"sceneName"], dic[@"peopleName"], dic[@"peopleNumber"]];
        BOOL res = [_db executeUpdate:deleteSql];
        if (!res) {
            NSLog(@"删除CheckScene:%@出错", dic);
        } else {
            NSLog(@"删除CheckScene:%@成功", dic);
        }
        [_db close];
    }
    return YES;
}
- (BOOL)deleteCheckSceneTableAll:(NSString *)key {
    if ([_db open]) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE from CheckScene WHERE CHECKSCENE = '%@'", key];
        BOOL res = [_db executeUpdate:deleteSql];
        if (!res) {
            NSLog(@"删除CheckScene:%@出错", key);
        } else {
            NSLog(@"删除CheckScene:%@成功", key);
        }
        [_db close];
    }
    return YES;
}
@end
