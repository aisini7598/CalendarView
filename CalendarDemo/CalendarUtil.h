//
//  CalendarUtil.h
//  CalendarDemo
//
//  Created by John on 2019/5/7.
//  Copyright © 2019 John. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalendarUtil : NSObject

+ (NSInteger)todayDateline;

+ (NSInteger)dateline:(NSInteger)otherDateline offsetByDay:(NSInteger)day;

+ (NSInteger)dateline:(NSInteger)otherDateline offsetByMonth:(NSInteger)month;

+ (NSInteger)dateline:(NSInteger)otherDateline offsetByYear:(NSInteger)year;

+ (NSInteger)firstDayOfMonth:(NSInteger)dateline;

+ (NSInteger)weekdayOfDateline:(NSInteger)dateline;

+ (NSInteger)diff:(NSInteger)from to:(NSInteger)to;
+ (NSInteger)diffMonth:(NSInteger)from to:(NSInteger)to;


@end

NS_ASSUME_NONNULL_END
