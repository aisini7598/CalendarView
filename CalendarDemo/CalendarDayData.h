//
//  CalendarDayData.h
//  CalendarDemo
//
//  Created by John on 2019/5/7.
//  Copyright © 2019 John. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalendarDayData : NSObject

- (instancetype)initWithDateline:(NSInteger)dateline;

@property (nonatomic) NSInteger dateline;
@property (nonatomic) NSInteger day;

@property (nonatomic) BOOL isActive;
@property (nonatomic) BOOL hasFinished;
@property (nonatomic) BOOL isToday;

@property (nonatomic) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
