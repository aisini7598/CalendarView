//
//  CalendarUtil.m
//  CalendarDemo
//
//  Created by John on 2019/5/7.
//  Copyright © 2019 John. All rights reserved.
//

#import "CalendarUtil.h"

typedef NS_ENUM(NSInteger, EDaylineOffsetType) {
    
    EDaylineOffsetTypeDay = 1,
    EDaylineOffsetTypeMonth,
    EDaylineOffsetTypeYear
};

@implementation CalendarUtil


+ (NSInteger)todayDateline {
    NSDateComponents *components = [[self p_gregorianCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    return [self p_datelineByYear:components.year month:components.month day:components.day];
}

+ (NSInteger)dateline:(NSInteger)otherDateline offsetByDay:(NSInteger)day {
    return [self p_dateline:otherDateline offsetType:EDaylineOffsetTypeDay offset:day];
}

+ (NSInteger)dateline:(NSInteger)otherDateline offsetByMonth:(NSInteger)month {
    return [self p_dateline:otherDateline offsetType:EDaylineOffsetTypeMonth offset:month];
}

+ (NSInteger)dateline:(NSInteger)otherDateline offsetByYear:(NSInteger)year {
    return [self p_dateline:otherDateline offsetType:EDaylineOffsetTypeYear offset:year];
}

+ (NSInteger)firstDayOfMonth:(NSInteger)dateline {
    return [self p_datelineByYear:[self p_yearOfDateline:dateline] month:[self p_monthOfDateline:dateline] day:1];
}

+ (NSInteger)weekdayOfDateline:(NSInteger)dateline {
    
    NSDateComponents *otherComponents = [[NSDateComponents alloc] init];
    otherComponents.day = [self p_dayOfDateline:dateline];
    otherComponents.month = [self p_monthOfDateline:dateline];
    otherComponents.year = [self p_yearOfDateline:dateline];
    
    NSCalendar *calendar = [self p_gregorianCalendar];
    NSDate *date = [calendar dateFromComponents:otherComponents];
    NSInteger weekday = [calendar component:NSCalendarUnitWeekday fromDate:date];
    weekday = weekday - 1;
    return weekday ?: 7;
}

+ (NSInteger)diff:(NSInteger)from to:(NSInteger)to {
    
    NSCalendar *calendar = [self p_gregorianCalendar];
    
    NSDateComponents *fromComps = [[NSDateComponents alloc] init];
    fromComps.day = [self p_dayOfDateline:from];
    fromComps.month = [self p_monthOfDateline:from];
    fromComps.year = [self p_yearOfDateline:from];
    
    NSDate *fromDate = [calendar dateFromComponents:fromComps];
    
    NSDateComponents *toComps = [[NSDateComponents alloc] init];
    toComps.day = [self p_dayOfDateline:to];
    toComps.month = [self p_monthOfDateline:to];
    toComps.year = [self p_yearOfDateline:to];
    
    NSDate *toDate = [calendar dateFromComponents:toComps];

    NSDateComponents *resultComponents = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    return resultComponents.day;
}

+ (NSInteger)diffMonth:(NSInteger)from to:(NSInteger)to {
    
    NSInteger yearOfFrom = [self p_yearOfDateline:from];
    NSInteger yearOfTo = [self p_yearOfDateline:to];
    
    NSInteger monthOfFrom = [self p_monthOfDateline:from];
    NSInteger monthOfTo = [self p_monthOfDateline:to];
    
    return (yearOfTo - yearOfFrom) * 12 + (monthOfTo - monthOfFrom);
}

//+ (NSInteger)datelineWithDate:(NSDate *)date {
//
//}
//
//+ (NSDate *)dateFormatByDateline:(NSInteger)dateline {
//
//}


#pragma private

+ (NSInteger)p_dayOfDateline:(NSInteger)dateline {
    return dateline % 100;
}

+ (NSInteger)p_monthOfDateline:(NSInteger)dateline {
    
    return  (dateline / 100) % 100;
}

+ (NSInteger)p_yearOfDateline:(NSInteger)dateline {
    
    return dateline / 10000;
}

+ (NSInteger)p_dateline:(NSInteger)dateline offsetType:(EDaylineOffsetType)offsetType offset:(NSInteger)offset {
    if (!offset) {
        return dateline;
    }
    NSDateComponents *components = [[NSDateComponents alloc] init];
    switch (offsetType) {
        case EDaylineOffsetTypeDay:
            components.day = offset;
            break;
        case EDaylineOffsetTypeYear:
            components.year = offset;
            break;
        case EDaylineOffsetTypeMonth:
            components.month = offset;
            break;
        default:
            break;
    }
    
    NSDateComponents *otherComponents = [[NSDateComponents alloc] init];
    otherComponents.day = [self p_dayOfDateline:dateline];
    otherComponents.month = [self p_monthOfDateline:dateline];
    otherComponents.year = [self p_yearOfDateline:dateline];
    
    NSCalendar *calendar = [self p_gregorianCalendar];
    NSDate *date = [calendar dateFromComponents:otherComponents];
    NSDate *newDate = [calendar dateByAddingComponents:components toDate:date options:0];
    components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:newDate];
    
    return [self p_datelineByYear:components.year month:components.month day:components.day];
}

+ (NSCalendar *)p_gregorianCalendar {
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSCalendar *calendar = [dictionary objectForKey:@"GREGORIAN_CALENDAR"];
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [dictionary setObject:calendar forKey:@"GREGORIAN_CALENDAR"];
    }
    return calendar;
}

+ (NSInteger)p_datelineByYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    return [[NSString stringWithFormat:@"%04ld%02ld%02ld",year,month,day] integerValue];
}

@end
