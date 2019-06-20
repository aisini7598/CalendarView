//
//  CalendarDayData.m
//  CalendarDemo
//
//  Created by John on 2019/5/7.
//  Copyright © 2019 John. All rights reserved.
//

#import "CalendarDayData.h"

@implementation CalendarDayData

- (instancetype)initWithDateline:(NSInteger)dateline {
    self = [super init];
    if (self) {
        _dateline = dateline;
    }
    return self;
}

- (NSInteger)day {
    _day = self.dateline % 100;
    return _day;
}

@end
