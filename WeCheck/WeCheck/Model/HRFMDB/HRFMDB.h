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
 *  @brief  查询签到情景
 *
 *  @param key 签到人员数组
 *
 *  @return 签到情景
 */
- (NSString *)queryInCheckSceneTableCheckScene:(NSArray *)key;
/**
 *  @author HaiRui
 *
 *  @brief  查询某个情景人数
 *
 *  @param key 情景名字
 *
 *  @return 情景人数
 */
- (NSString *)queryInCheckSceneTableNum:(NSString *)key;
/**
 *  @author HaiRui
 *
 *  @brief  根据情景名查询所有people
 *
 *  @param key 情景名字
 *
 *  @return 人员数组
 */
- (id)queryInCheckSceneTable:(NSString *)key;
/**
 *  @author HaiRui
 *
 *  @brief  根据人员代号查询名字
 *
 *  @param array 人员代号数组
 *  @param key   签到情景
 *
 *  @return 人员数组
 */
- (id)queryInCheckSceneTableCheckPeople:(NSArray *)array objectForKey:(NSString *)key;
/**
 *  @author HaiRui
 *
 *  @brief  修改people信息
 *
 *  @param dicNew 新的people信息
 *  @param dicOld 旧的people信息
 *
 *  @return YES修改成功
 */
- (BOOL)updateCheckSceneTable:(NSDictionary *)dicNew withOld:(NSDictionary *)dicOld;
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
/**
 *  @author HaiRui
 *
 *  @brief  删除情景中所有people
 *
 *  @param key 情景名字
 *
 *  @return YES删除成功
 */
- (BOOL)deleteCheckSceneTableAll:(NSString *)key;
#pragma mark - CheckRecord表方法
/**
 *  @author HaiRui
 *
 *  @brief  插入签到记录
 *
 *  @param array    签到人员数组
 *  @param arrayAll 所有应签到人员
 *  @param key      签到情景
 *
 *  @return YES插入成功
 */
- (BOOL)insertInToCheckRecordTable:(NSArray *)array allPeople:(NSArray *)arrayAll objectForKey:(NSString *)key;
/**
 *  @author HaiRui
 *
 *  @brief  查询签到记录数组
 *
 *  @return 签到记录数组  字典包括 checkscene checktime
 */
- (id)queryInCheckRecordTable;
/**
 *  @author HaiRui
 *
 *  @brief  查询所有签到状态详情
 *
 *  @return 状态字典
 */
- (id)queryInCheckRecordTableForAllScene;
/**
 *  @author HaiRui
 *
 *  @brief  查询每种情景的名字
 *
 *  @return 情景数组
 */
- (id)queryInCheckRecordTableForEachScene;
/**
 *  @author HaiRui
 *
 *  @brief  查询每种情景签到状态详情
 *
 *  @param mutArray 情景名字数组
 *
 *  @return 情景签到状态详情
 */
- (id)queryInCheckRecordTableForEachSceneDetail:(NSMutableArray *)mutArray;
/**
 *  @author HaiRui
 *
 *  @brief  查询每次签到状态详情
 *
 *  @param checkTime 签到时间
 *
 *  @return 状态字典
 */
- (id)queryInCheckRecordTableForEachTime:(NSString *)checkTime;
/**
 *  @author HaiRui
 *
 *  @brief  查询签到详情
 *
 *  @param checkTime 签到时间
 *  @param key       签到情景
 *
 *  @return 签到详情
 */
- (id)queryInCheckRecordTableForEdit:(NSString *)checkTime  objectForKey:(NSString *)key;
/**
 *  @author HaiRui
 *
 *  @brief  更新签到记录
 *
 *  @param dicCheck  原签到记录
 *  @param checkTime 签到时间
 *
 *  @return YES修改成功
 */
- (BOOL)updateCheckRecordTableForEdit:(NSDictionary *)dicCheck objectForKey:(NSString *)checkTime;
@end
