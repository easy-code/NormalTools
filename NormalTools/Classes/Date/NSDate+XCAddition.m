//
//  NSDate+XCAddition.m
//  cheng
//
//  Created by chengfeng on 2020/2/7.
//  Copyright © 2020 chengfeng All rights reserved.
//

#import "NSDate+XCAddition.h"
#import <YYCategories/YYCategories.h>

@implementation NSDate (XCAddition)

+ (instancetype)dateWithString:(NSString *)dateStr {
    NSDateFormatter *fmt = [NSDateFormatter new];
    fmt.dateFormat = kXCDateFormat;
    return [fmt dateFromString:dateStr];
}

- (NSInteger)intervalYearsToDate:(NSDate *)toDate {
    NSCalendarUnit unitFlags = NSCalendarUnitYear;
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *newFromDate = [calendar dateFromComponents:[calendar components:unitFlags fromDate:toDate?:[NSDate date]]];
    NSDate *newToDate = [calendar dateFromComponents:[calendar components:unitFlags fromDate:self]];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear fromDate:newFromDate toDate:newToDate options:0];
//    INFO(@"天:%ld 秒:%.0f from:%@ to:%@", dateComponents.day, [self timeIntervalSinceDate:toDate?:[NSDate date]], [self stringWithFormat:kXCDateFormat], [toDate?:[NSDate date] stringWithFormat:kXCDateFormat]);
    return dateComponents.year;
}

- (NSInteger)intervalMonthsToDate:(NSDate *)toDate {
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *newFromDate = [calendar dateFromComponents:[calendar components:unitFlags fromDate:toDate?:[NSDate date]]];
    NSDate *newToDate = [calendar dateFromComponents:[calendar components:unitFlags fromDate:self]];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitMonth fromDate:newFromDate toDate:newToDate options:0];
//    INFO(@"天:%ld 秒:%.0f from:%@ to:%@", dateComponents.day, [self timeIntervalSinceDate:toDate?:[NSDate date]], [self stringWithFormat:kXCDateFormat], [toDate?:[NSDate date] stringWithFormat:kXCDateFormat]);
    return dateComponents.month;
}

- (NSInteger)intervalDaysToDate:(NSDate *)toDate {
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *newFromDate = [calendar dateFromComponents:[calendar components:unitFlags fromDate:toDate?:[NSDate date]]];
    NSDate *newToDate = [calendar dateFromComponents:[calendar components:unitFlags fromDate:self]];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay fromDate:newFromDate toDate:newToDate options:0];
//    INFO(@"天:%ld 秒:%.0f from:%@ to:%@", dateComponents.day, [self timeIntervalSinceDate:toDate?:[NSDate date]], [self stringWithFormat:kXCDateFormat], [toDate?:[NSDate date] stringWithFormat:kXCDateFormat]);
    return dateComponents.day;
}

- (NSString *)dateString {
    return [self stringToDate:[NSDate date]];
}

- (NSString *)stringToDate:(NSDate *)toDate {
    NSInteger day = [self intervalDaysToDate:toDate];
    if (day > 0) {
        return [self stringWithFormat:kXCDateFormat];
    } else if (day == 0) {
        NSTimeInterval interval = [self timeIntervalSinceDate:toDate];
        if (interval > 0) {
            //未来时间（可能是误差导致）
            return [self stringWithFormat:kXCDateFormat];
        }
        //当天
        if (interval <= 0 && interval >= -5 * 60) {
            return @"刚刚";
        } else if (interval < -5*60 && interval > -60 * 60) {
            return @"5分钟前";
        } else {
            return [self stringWithFormat:@"HH:mm"];
        }
    } else if (day == -1) {
        return [self stringWithFormat:@"昨天 HH:mm"];
    } else {
        if ([self intervalYearsToDate:toDate] < 0) {
            return [self stringWithFormat:kXCDateFormat];
        } else {
            return [self stringWithFormat:@"MM-dd HH:mm"];
        }
    }
}

- (NSString *)simpleStringToDate:(NSDate *)toDate {
    NSInteger day = [self intervalDaysToDate:toDate];
    if (day == 0) {
        return [self stringWithFormat:@"今天 HH:mm"];
    }
    return [self stringWithFormat:@"MM-dd HH:mm"];
}

@end
