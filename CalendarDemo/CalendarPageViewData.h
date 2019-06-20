//
//  CalendarPageViewData.h
//  CalendarDemo
//
//  Created by John on 2019/5/7.
//  Copyright © 2019 John. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CalendarPageViewData;
@class CalendarDayData;
@class CalendarPageBaseView;

@protocol CalendarPageDataSource <NSObject>

- (CalendarDayData *)calendarDataWithView:(CalendarPageBaseView *)calendarPageView dayOfIndex:(NSInteger)index;

@end

@protocol CalendarPageDelegate <NSObject>

- (void)calendarDataView:(CalendarPageBaseView *)calendarPageView didselectedAtIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger,ECalendarShowMode) {
    ECalendarShowModeMonth,
    ECalendarShowModeWeek
};

@interface CalendarPageViewData : NSObject

@property (nonatomic, weak) id <CalendarPageDataSource> dataSource;
@property (nonatomic, weak) id <CalendarPageDelegate> delegate;

@property (nonatomic) ECalendarShowMode mode;

@property (nonatomic) NSInteger weekBeginDay;
@property (nonatomic) NSInteger weekEndDay;


@end

NS_ASSUME_NONNULL_END
