//
//  CalendarWeekToolBar.m
//  CalendarDemo
//
//  Created by John on 2019/5/8.
//  Copyright © 2019 John. All rights reserved.
//

#import "CalendarWeekToolBar.h"

CGFloat minimumGap = 5;


@implementation CalendarWeekToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (NSArray *)weekDays {
   NSArray * weekdayStrings = [NSArray arrayWithObjects:@"周日", @"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    return weekdayStrings;
}

- (void)drawRect:(CGRect)rect {
    NSArray *weekDays = [self weekDays];
    UIFont *font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    UIColor *textColor = [UIColor blackColor];
    CGFloat width = (rect.size.width - 6 * minimumGap) * 1.0f / 7;
    
    NSDictionary *attrubutes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor};
    
    for (NSInteger i = 0; i < weekDays.count; i++) {
        NSString *week = weekDays[i];
        CGSize size = [week  sizeWithAttributes:attrubutes];
        CGFloat paddingY = (rect.size.height - size.height) / 2;
        CGFloat paddingX = (width - size.width) / 2;
        paddingX += (width + minimumGap) * i;
        [week drawAtPoint:CGPointMake(paddingX, paddingY) withAttributes:attrubutes];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
