
//
//  CalendarPageView.m
//  CalendarDemo
//
//  Created by John on 2019/5/7.
//  Copyright © 2019 John. All rights reserved.
//

#import "CalendarPageView.h"
#import "CalendarDayCell.h"
#import "CalendarDayData.h"

static int columnCount = 7;
static int rowCount = 6;

@implementation CalendarPageView


- (NSInteger)columnOfNumber {
    return columnCount;
}

- (NSInteger)rowOfNumber {
    return rowCount;
}

/*
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
