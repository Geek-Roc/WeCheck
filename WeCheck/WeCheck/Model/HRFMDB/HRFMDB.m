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
        NSString *sqlCreateTable1 =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CheckScene (CHECKSCENE TEXT NOT NULL, PEOPLENAME TEXT NOT NULL, PEOPLENUMBER TEXT NOT NULL, PRIMARY KEY (CHECKSCENE, PEOPLENAME, PEOPLENUMBER))"];
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
#pragma mark - KeyValue表方法
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
        return result;
    }
    return nil;
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
#pragma mark - CheckScene表方法
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
- (NSString *)queryInCheckSceneTableCheckScene:(NSArray *)array {
    NSString *checkScene;
    NSString *string = @"";
    for (NSString *s in array) {
        string = [string stringByAppendingFormat:@"%@, ", s];
    }
    string = [string substringToIndex:string.length-2];
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT CheckScene, count() AS A FROM CheckScene WHERE PEOPLENUMBER IN (%@) GROUP BY CHECKSCENE ORDER BY A DESC", string];
        FMResultSet *rs = [_db executeQuery:sql];
        if ([rs next]) {
            checkScene = [rs stringForColumn:@"CHECKSCENE"];
        }
        [_db close];
    }
    return checkScene;
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
            [dicPeople setObject:[rs stringForColumn:@"CHECKSCENE"] forKey:@"CHECKSCENE"];
            [peopleArr addObject:dicPeople];
        }
        [_db close];
    }
    return peopleArr;
}
- (id)queryInCheckSceneTableCheckPeople:(NSArray *)array objectForKey:(NSString *)key {
    NSMutableArray *peopleArr = [NSMutableArray array];
    NSString *string = @"";
    for (NSString *s in array) {
        string = [string stringByAppendingFormat:@"%@, ", s];
    }
    string = [string substringToIndex:string.length-2];
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM CheckScene WHERE PEOPLENUMBER IN (%@) AND CHECKSCENE = '%@'",string , key];
        FMResultSet *rs = [_db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *dicPeople = [NSMutableDictionary dictionary];
            [dicPeople setObject:[rs stringForColumn:@"PEOPLENAME"] forKey:@"peopleName"];
            [dicPeople setObject:[rs stringForColumn:@"PEOPLENUMBER"] forKey:@"peopleNumber"];
            [dicPeople setObject:[rs stringForColumn:@"CHECKSCENE"] forKey:@"CHECKSCENE"];
            [peopleArr addObject:dicPeople];
        }
        [_db close];
    }
    return peopleArr;
}
- (BOOL)updateCheckSceneTable:(NSDictionary *)dicNew withOld:(NSDictionary *)dicOld {
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE CheckScene SET PEOPLENAME = '%@', PEOPLENUMBER = '%@' WHERE CHECKSCENE = '%@' AND PEOPLENAME = '%@' AND PEOPLENUMBER = '%@'", dicNew[@"peopleName"], dicNew[@"peopleNumber"], dicOld[@"checkScene"], dicOld[@"peopleName"], dicOld[@"peopleNumber"]];
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
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE from CheckScene WHERE CHECKSCENE = '%@' AND PEOPLENAME = '%@' AND PEOPLENUMBER = '%@'", dic[@"checkScene"], dic[@"peopleName"], dic[@"peopleNumber"]];
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
#pragma mark - CheckRecord表方法
- (BOOL)insertInToCheckRecordTable:(NSArray *)array allPeople:(NSArray *)arrayAll objectForKey:(NSString *)key {
    if ([_db open]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *stringTime = [formatter stringFromDate:[NSDate date]];
        for (NSDictionary *dic in arrayAll) {
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO CheckRecord (CHECKSCENE, PEOPLENAME, PEOPLENUMBER, PEOPLESTATE, CHECKTIME) VALUES (?, ?, ?, ?, ?)"];
            BOOL res;
            if ([array containsObject:dic])
                //0签到 1迟到 2缺席
                res = [_db executeUpdate:sql,key,dic[@"peopleName"],dic[@"peopleNumber"],@"0",stringTime];
            else
                res = [_db executeUpdate:sql,key,dic[@"peopleName"],dic[@"peopleNumber"],@"2",stringTime];
            if (!res) {
                NSLog(@"插入CheckScene失败");
                return NO;
            } else {
                NSLog(@"插入CheckScene成功");
            }
        }
        [_db close];
    }
    return YES;
}
- (id)queryInCheckRecordTable {
    NSMutableArray *checkRecords = [NSMutableArray array];
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT CHECKSCENE,CHECKTIME FROM CheckRecord GROUP BY CHECKTIME"];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *checkRecord = [NSMutableDictionary dictionary];
            [checkRecord setObject:[rs stringForColumn:@"CHECKSCENE"] forKey:@"checkScene"];
            [checkRecord setObject:[rs stringForColumn:@"CHECKTIME"] forKey:@"checkTime"];
            [checkRecords addObject:checkRecord];
        }
        [_db close];
    }
    return checkRecords;
}
- (id)queryInCheckRecordTableForAllScene {
    NSMutableDictionary *checkRecord = [NSMutableDictionary dictionary];
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT PEOPLESTATE, count() AS A FROM CheckRecord GROUP BY PEOPLESTATE"];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            [checkRecord setObject:[rs stringForColumn:@"A"] forKey:[rs stringForColumn:@"PEOPLESTATE"]];
        }
        [_db close];
    }
    return checkRecord;
}
- (id)queryInCheckRecordTableForEachScene {
    NSMutableArray *eachScenes = [NSMutableArray array];
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT DISTINCT CHECKSCENE FROM CheckRecord"];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *eachScene = [NSMutableDictionary dictionary];
            [eachScene setObject:[rs stringForColumn:@"CHECKSCENE"] forKey:@"checkScene"];
            [eachScenes addObject:eachScene];
        }
        [_db close];
    }
    return eachScenes;
}
- (id)queryInCheckRecordTableForEachSceneDetail:(NSMutableArray *)mutArray {
    if ([_db open]) {
        for (NSMutableDictionary *mutDic in mutArray) {
            NSString * sql = [NSString stringWithFormat:@"SELECT PEOPLESTATE, count() AS A FROM CheckRecord WHERE CHECKSCENE = '%@' GROUP BY CHECKSCENE, PEOPLESTATE", mutDic[@"checkScene"]];
            FMResultSet * rs = [_db executeQuery:sql];
            while ([rs next]) {
                [mutDic setObject:[rs stringForColumn:@"A"] forKey:[rs stringForColumn:@"PEOPLESTATE"]];
            }
        }
        [_db close];
    }
    return mutArray;
}
- (id)queryInCheckRecordTableForEachPeople:(NSMutableArray *)mutArray {
    if ([_db open]) {
        for (NSMutableDictionary *mutDic in mutArray) {
            NSString * sql = [NSString stringWithFormat:@"SELECT PEOPLESTATE,count() AS A FROM CheckRecord WHERE CHECKSCENE = '%@' AND PEOPLENUMBER = '%@' GROUP BY PEOPLESTATE", mutDic[@"checkScene"], mutDic[@"peopleNumber"]];
            FMResultSet * rs = [_db executeQuery:sql];
            while ([rs next]) {
                [mutDic setObject:[rs stringForColumn:@"A"] forKey:[rs stringForColumn:@"PEOPLESTATE"]];
            }
        }
        [_db close];
    }
    return mutArray;
}
- (id)queryInCheckRecordTableForEachPeopleDetail:(NSMutableDictionary *)mutDic {
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT PEOPLESTATE,CHECKTIME FROM CheckRecord WHERE CHECKSCENE = '%@' AND PEOPLENUMBER = '%@'", mutDic[@"checkScene"], mutDic[@"peopleNumber"]];
        FMResultSet * rs = [_db executeQuery:sql];
        NSMutableArray *mutArr = [NSMutableArray array];
        while ([rs next]) {
            NSMutableDictionary *mutDicTemp = [NSMutableDictionary dictionary];
            [mutDicTemp setObject:[rs stringForColumn:@"CHECKTIME"] forKey:@"checkTime"];
            [mutDicTemp setObject:[rs stringForColumn:@"PEOPLESTATE"] forKey:@"peopleState"];
            [mutArr addObject:mutDicTemp];
        }
        [mutDic setObject:mutArr forKey:@"checkDetail"];
        [_db close];
    }
    return mutDic;
}
- (id)queryInCheckRecordTableForEachTime:(NSString *)checkTime {
    NSMutableDictionary *checkRecord = [NSMutableDictionary dictionary];
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT PEOPLESTATE, count() AS A FROM CheckRecord WHERE CHECKTIME = '%@'  GROUP BY PEOPLESTATE", checkTime];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            [checkRecord setObject:[rs stringForColumn:@"A"] forKey:[rs stringForColumn:@"PEOPLESTATE"]];
        }
        [_db close];
    }
    return checkRecord;
}
- (id)queryInCheckRecordTableForEdit:(NSString *)checkTime  objectForKey:(NSString *)key {
    NSMutableArray *checkRecords = [NSMutableArray array];
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM CheckRecord WHERE CHECKTIME = '%@' AND CHECKSCENE = '%@'", checkTime, key];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *checkRecord = [NSMutableDictionary dictionary];
            [checkRecord setObject:[rs stringForColumn:@"PEOPLENAME"] forKey:@"peopleName"];
            [checkRecord setObject:[rs stringForColumn:@"PEOPLESTATE"] forKey:@"peopleState"];
            [checkRecord setObject:[rs stringForColumn:@"PEOPLENUMBER"] forKey:@"peopleNumber"];
            [checkRecords addObject:checkRecord];
        }
        [_db close];
    }
    return checkRecords;
}
- (BOOL)updateCheckRecordTableForEdit:(NSDictionary *)dicCheck objectForKey:(NSString *)checkTime {
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE CheckRecord SET PEOPLESTATE = '%@' WHERE CHECKTIME = '%@' AND PEOPLENAME = '%@' AND PEOPLENUMBER = '%@'", dicCheck[@"peopleState"], checkTime, dicCheck[@"peopleName"], dicCheck[@"peopleNumber"]];
        BOOL res = [_db executeUpdate:sql];
        if (!res) {
            NSLog(@"修改CheckRecord失败");
            return NO;
        } else {
            NSLog(@"修改CheckRecord成功");
        }
        [_db close];
    }
    return YES;
}
- (BOOL)deleteCheckRecordTable:(NSDictionary *)dic {
    if ([_db open]) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE from CheckRecord WHERE CHECKSCENE = '%@' AND CHECKTIME = '%@'", dic[@"checkScene"], dic[@"checkTime"]];
        BOOL res = [_db executeUpdate:deleteSql];
        if (!res) {
            NSLog(@"删除CheckRecord:%@出错", dic);
        } else {
            NSLog(@"删除CheckRecord:%@成功", dic);
        }
        [_db close];
    }
    return YES;
}
@end
