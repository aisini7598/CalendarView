//
//  CalendarView.h
//  CalendarDemo
//
//  Created by John on 2019/5/6.
//  Copyright © 2019 John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarPageViewData.h"

NS_ASSUME_NONNULL_BEGIN

@class CalendarView;


@protocol CalendarViewDelegate <NSObject>

- (void)calendarView:(CalendarView *)calendarView currentDateline:(NSInteger)dateline;
- (void)calendarView:(CalendarView *)calendarView didSelectedDateline:(NSInteger)dateline;

@end


@interface CalendarView : UIView

@property (nonatomic) NSInteger currentMonthDay;
@property (nonatomic) NSInteger currentDay;
@property (nonatomic) ECalendarShowMode currentMode;

@property (nonatomic, weak) id <CalendarViewDelegate> delegate;

- (void)setCurrentMonth:(NSInteger)currentMonthDay day:(NSInteger)currentDay;

- (void)reloadData;
- (void)nextPage;
- (void)prePage;
- (void)backToToday;


@end

NS_ASSUME_NONNULL_END
