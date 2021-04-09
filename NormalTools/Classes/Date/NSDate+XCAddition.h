//
//  NSDate+XCAddition.h
//  cheng
//
//  Created by chengfeng on 2020/2/7.
//  Copyright © 2020 chengfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYCategories/NSDate+YYAdd.h>

#define kXCDateFormat   @"yyyy-MM-dd HH:mm:ss"
#define kXCFullYMD  @"yyyy-MM-dd"
#define XCDate(formatStr)  [NSDate dateWithString:formatStr]

@interface NSDate (XCAddition)

/// 初始化日期对象
/// @param dateStr 格式化的日期yyyy-MM-dd HH:mm:ss
+ (instancetype)dateWithString:(NSString *)dateStr;

/// 计算到toDate自然间隔年数
/// @param toDate nil表示当前日期
- (NSInteger)intervalYearsToDate:(NSDate *)toDate;

/// 计算到toDate自然间隔月数
/// @param toDate nil表示当前日期
- (NSInteger)intervalMonthsToDate:(NSDate *)toDate;

/// 计算到toDate自然间隔天数
/// @param toDate nil表示当前日期
- (NSInteger)intervalDaysToDate:(NSDate *)toDate;

/**
 格式化的日期
 刚刚、5分钟前、08:00、昨天 08:00、02-07  08:00、2019-02-07  08:00
 */
- (NSString *)dateString;

/**
 格式化的日期
 刚刚、5分钟前、08:00、昨天 08:00、02-07  08:00、2019-02-07  08:00
 @param toDate 相对与日期（一般都是当前日期）
*/
- (NSString *)stringToDate:(NSDate *)toDate;

/**
 简单日期
 
 今天、03-09 10:00
 
 */
- (NSString *)simpleStringToDate:(NSDate *)toDate;

@end
