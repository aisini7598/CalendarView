//
//  CalendarView.m
//  CalendarDemo
//
//  Created by John on 2019/5/6.
//  Copyright © 2019 John. All rights reserved.
//

#import "CalendarView.h"
#import "CalendarPageView.h"
#import "CalendarDayData.h"
#import "CalendarUtil.h"
#import "CalendarWeekToolBar.h"
#import "CalendarWeekPageView.h"
#import "PFInfiniteView.h"

static NSInteger pageCount = 3;

static CGFloat weeklyHeight () {return 50;}


@interface CalendarWeekToastView : UIView

@property (nonatomic, copy) NSString *weekDurationText;
@property (nonatomic, weak) UILabel *durationLabel;

- (void)show;
- (void)hide;

@end

@implementation CalendarWeekToastView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        UILabel *durationLabel = [[UILabel alloc] initWithFrame:self.bounds];
        durationLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        durationLabel.textColor = UIColor.blackColor;
        durationLabel.textAlignment = NSTextAlignmentCenter;
        durationLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:durationLabel];
        _durationLabel = durationLabel;
    }
    return self;
}

- (void)setWeekDurationText:(NSString *)weekDurationText {
    _weekDurationText = weekDurationText;
    self.durationLabel.text = weekDurationText;
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.durationLabel.frame = self.bounds;
}

- (void)show {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    }];
}

@end

@interface CalendarView ()<UIScrollViewDelegate, CalendarPageDataSource, CalendarPageDelegate, PFInfiniteViewDatasource, PFInfiniteViewDelegate>
{
    @public
    CGFloat _lastOffsetX;
    
}
@property (nonatomic, weak) UIScrollView *containerView;
@property (nonatomic, weak) UIView *weeklyView;
@property (nonatomic, copy) NSArray *weekPageView;

@property (nonatomic) NSMutableDictionary *beginDayCache;

@property (nonatomic) NSInteger crossSelectedDay;

@property (nonatomic, weak) PFInfiniteView *infiniteView;


@end

@implementation CalendarView

- (NSMutableDictionary *)beginDayCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.beginDayCache = [NSMutableDictionary dictionary];
    });
    return _beginDayCache;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCalendarModel:(ECalendarShowMode)calendarMode {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _currentMode = calendarMode;
    }
    return self;
}

- (void)setCurrentMode:(ECalendarShowMode)currentMode {
    _currentMode = currentMode;
    [self initViews];
}

- (void)initViews {
    CalendarWeekToolBar *weeklyView = [[CalendarWeekToolBar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, weeklyHeight())];
    weeklyView.backgroundColor = UIColor.redColor;
    [self addSubview:weeklyView];
    _weeklyView = weeklyView;
   
    PFInfiniteView *infiniteView = [[PFInfiniteView alloc] initWithFrame:CGRectMake(0, weeklyHeight(), self.bounds.size.width, self.bounds.size.height - weeklyHeight())];
    infiniteView.datasource = self;
    infiniteView.delegate = self;
    [self addSubview:infiniteView];
    _infiniteView = infiniteView;
}

- (void)reloadData {
    [self.infiniteView reloadData];
}

- (void)resetWeekPageFrame {
    for (NSInteger i = 0; i < pageCount; i++) {
        UIView *pageView = self.weekPageView[i];
        pageView.frame = CGRectMake(i * pageView.frame.size.width, 0, pageView.bounds.size.width, pageView.bounds.size.height);
    }
}

//- (void)updatePage:(BOOL)isLeft {
//    NSMutableArray *pageViews = self.pageViews.mutableCopy;
//    CalendarPageView *page = nil;
//    if (!isLeft) {
//        page = pageViews.lastObject;
//        [pageViews removeLastObject];
//        [pageViews insertObject:page atIndex:0];
//    } else {
//        page = pageViews.firstObject;
//        [pageViews removeObjectAtIndex:0];
//        [pageViews addObject:page];
//    }
//
//    self.pageViews = pageViews.copy;
//    [self resetPageFrame];
//    [page reloadData];
//
//}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGFloat offsetX =  scrollView.contentOffset.x;
    _lastOffsetX = offsetX;
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSInteger index = floor((scrollView.contentOffset.x + scrollView.frame.size.width / 2) / scrollView.frame.size.width); // 计算偏移后的page索引
//    NSInteger middleIndex = 0;//[self middleIndex];
//    if (middleIndex != index) {
//        BOOL scrollToLeft = YES;
//        if (index < middleIndex) {
//            scrollToLeft = NO;
//        }
//
//        scrollView.contentOffset = CGPointMake(middleIndex * scrollView.frame.size.width, 0);
//
//        self.currentMonthDay = [CalendarUtil dateline:self.currentMonthDay offsetByMonth:scrollToLeft ?:-1];
//        self.currentDay = self.currentDay == [CalendarUtil todayDateline] ? self.currentDay : self.currentMonthDay;
//
//        self.currentWeekDateline = [CalendarUtil dateline:self.currentWeekDateline offsetByDay:7 * (scrollToLeft?1:-1)];
//
//        if ([CalendarUtil firstDayOfMonth:self.currentDay] != self.currentMonthDay) {
//            self.currentDay = self.currentMonthDay;
//        }
//
//        [self updatePage:scrollToLeft];
//        [self updateWeekPage:scrollToLeft];
//
//        [self refreshCurrent];
//        [self refreshWeekCurrent];
//    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:currentDateline:)]) {
//        [self.delegate calendarView:self currentDateline:self.currentDay];
//    }
//}

#pragma mark infinite delegate && datasource

- (id<PFInfiniteViewProtocol>)pageView {
    CalendarPageViewData *viewModel = [CalendarPageViewData new];
    viewModel.dataSource = self;
    viewModel.delegate = self;
    viewModel.mode = self.currentMode;
    
    if (self.currentMode == ECalendarShowModeMonth) {
        CalendarPageView *pageView = [[CalendarPageView alloc] initWithViewModel:viewModel];
        pageView.bounds = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
        pageView.backgroundColor = RandomColor();
        return pageView;
    } else {
        CalendarWeekPageView *pageView = [[CalendarWeekPageView alloc] initWithViewModel:viewModel];
        pageView.bounds = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
        pageView.backgroundColor = RandomColor();
        pageView.weekCoverView = [[CalendarWeekToastView alloc] initWithFrame:pageView.bounds];
        pageView.weekCoverView.alpha = 0;
        return pageView;
    }
}

- (void)infiniteView:(PFInfiniteView *)infiniteView scrollToLeft:(BOOL)isLeft {
    if (self.currentMode == ECalendarShowModeMonth) {
        self.currentMonthDay = [CalendarUtil dateline:self.currentMonthDay offsetByMonth:isLeft ?:-1];
        
        if (self.crossSelectedDay > 0) {
            self.currentDay = self.crossSelectedDay;
            self.crossSelectedDay = 0;
        } else {
            self.currentDay = [CalendarUtil dateline:self.currentDay offsetByMonth:isLeft ?: -1];
        }
        if ([CalendarUtil firstDayOfMonth:self.currentDay] != self.currentMonthDay) {
            self.currentDay = self.currentMonthDay;
        }
    } else {
        self.currentDay = [CalendarUtil dateline:self.currentDay offsetByDay:(isLeft? 1:-1) * 7];
        self.currentMonthDay = [CalendarUtil firstDayOfMonth:self.currentDay];
    }
}

- (void)infiniteViewEndScroll:(PFInfiniteView *)infiniteView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:currentDateline:)]) {
        [self.delegate calendarView:self currentDateline:self.currentDay];
    }
    
    if (self.currentMode == ECalendarShowModeWeek) {
        for (NSInteger i = 0; i < 3; i++) {
            CalendarPageBaseView *pageView = (CalendarPageBaseView *)[self.infiniteView pageOfIndex:i];
            [(CalendarWeekToastView *)pageView.weekCoverView hide];
        }
    }
}

- (void)infiniteView:(PFInfiniteView *)infiniteView atIndex:(NSInteger)index {
    [self p_refreshCurrentIndex:index];
}

- (void)reloadCurrent {
    for (NSUInteger i = 0; i < 3; i++) {
        [self p_refreshCurrentIndex:i];
    }
}

- (void)p_refreshCurrentIndex:(NSInteger)atIndex {
    
    CalendarPageBaseView *pageView = (CalendarPageBaseView *)[self.infiniteView pageOfIndex:atIndex];
    [pageView reloadData];
    
    NSInteger offset = atIndex - [self.infiniteView middleIndex];
    NSInteger dayOfIndex = 0;
    if (pageView.viewModel.mode == ECalendarShowModeMonth) {
        NSInteger dateline = [CalendarUtil dateline:self.currentDay offsetByMonth:offset];
        dayOfIndex = [self dayIndexOfPage:atIndex dateline:dateline];
    } else {
        NSInteger dateline = [CalendarUtil dateline:self.currentDay offsetByDay:7 * offset];
        dayOfIndex = [self dayIndexOfWeekPage:atIndex dateline:dateline];
        
        pageView.viewModel.weekBeginDay = [CalendarUtil dateline:dateline offsetByDay:-dayOfIndex];
        pageView.viewModel.weekEndDay = [CalendarUtil dateline:pageView.viewModel.weekBeginDay offsetByDay:7];
        
    }
    [pageView selectedIndex:dayOfIndex];
}

- (void)infiniteViewBeginScroll:(nonnull PFInfiniteView *)infiniteView {
    if (self.currentMode == ECalendarShowModeWeek) {
        for (NSInteger i = 0; i < 3; i++) {
            CalendarPageBaseView *pageView = (CalendarPageBaseView *)[self.infiniteView pageOfIndex:i];
            CGRect frame = self.bounds;
            frame.origin.y = -weeklyHeight();
            pageView.weekCoverView.frame = frame;
            
            [(CalendarWeekToastView *)pageView.weekCoverView show];
            [(CalendarWeekToastView *)pageView.weekCoverView setWeekDurationText:[self weekDurationTextWithBegin:pageView.viewModel.weekBeginDay end:pageView.viewModel.weekEndDay]];
        }
    }
}



#pragma mark private

- (NSString *)weekDurationTextWithBegin:(NSInteger)begin end:(NSInteger)end {
    NSString *ret = @"";
    BOOL isSameMonth = [CalendarUtil firstDayOfMonth:begin] == [CalendarUtil firstDayOfMonth:end];
    if (isSameMonth) {
        ret = [NSString stringWithFormat:@"%ld月 %ld日 - %ld日",[self monthOfDateline:begin],[self dayOfDateline:begin],[self dayOfDateline:end]];
    } else {
        ret = [NSString stringWithFormat:@"%ld月 %ld日 - %ld月 %ld日",[self monthOfDateline:begin],[self dayOfDateline:begin],[self monthOfDateline:end],[self dayOfDateline:end]];

    }
    return ret;
}

- (NSInteger)dayOfDateline:(NSInteger)dateline {
    return dateline % 100;
}

- (NSInteger)monthOfDateline:(NSInteger)dateline {
    return (dateline / 100) % 100;
}

- (NSInteger)dayIndexOfPage:(NSInteger)pageIndex dateline:(NSInteger)dateline {
    NSInteger offset = pageIndex - [self.infiniteView middleIndex];
    NSInteger month = [CalendarUtil dateline:self.currentMonthDay offsetByMonth:offset];
    NSInteger beginDay = [self p_beginOfMonth:month];
    NSInteger diff = [CalendarUtil diff:beginDay to:dateline];
    return diff;
}

- (NSInteger)dayIndexOfWeekPage:(NSInteger)pageIndex dateline:(NSInteger)dateline {
    NSInteger weekdayOfMonth = [CalendarUtil weekdayOfDateline:dateline];
    if (weekdayOfMonth == 7) {
        return 0;
    } else {
        return weekdayOfMonth;
    }
}

- (NSInteger)p_beginOfMonth:(NSInteger)month {
    NSInteger firstDayOfMonth = [CalendarUtil firstDayOfMonth:month];
    NSNumber *beginDayNumber = self.beginDayCache[@(firstDayOfMonth)];
    NSInteger beginDay;
    if (beginDayNumber) {
        beginDay = beginDayNumber.integerValue;
    } else {
        NSInteger weekdayOfMonth = [CalendarUtil weekdayOfDateline:firstDayOfMonth];
        if (weekdayOfMonth == 7) {
            beginDay = firstDayOfMonth;
        } else
            beginDay = [CalendarUtil dateline:firstDayOfMonth offsetByDay:-weekdayOfMonth];
        
        self.beginDayCache[@(firstDayOfMonth)] = @(beginDay);
    }
    return beginDay;
}

- (NSInteger)datelineOfPageIndex:(NSInteger)pageIndex dayIndex:(NSInteger)dayIndex {
    NSInteger offset = pageIndex - [self.infiniteView middleIndex];
    NSInteger month = [CalendarUtil dateline:self.currentMonthDay offsetByMonth:offset];
    NSInteger beginDay = [self p_beginOfMonth:month];
    NSInteger dateline = [CalendarUtil dateline:beginDay offsetByDay:dayIndex];
    
    return dateline;
}

- (NSInteger)datelineOfWeekIndex:(NSInteger)weekPageIndex dayIndex:(NSInteger)dayIndex {
    NSInteger offset = weekPageIndex - [self.infiniteView middleIndex];
    NSInteger weekOffsetDateline = [CalendarUtil dateline:self.currentDay offsetByDay:offset * 7];
    
    NSInteger weekdayOfDay = [CalendarUtil weekdayOfDateline:weekOffsetDateline];
    NSInteger firstDayOfWeek = 0;
    
    if (weekdayOfDay == 7) {
        firstDayOfWeek = weekOffsetDateline;
    } else {
        firstDayOfWeek = [CalendarUtil dateline:weekOffsetDateline offsetByDay:-weekdayOfDay];
    }
    return [CalendarUtil dateline:firstDayOfWeek offsetByDay:dayIndex];
}

#pragma mark publick methed

- (void)nextPage {
    
    [self.infiniteView nextPage];
    //    if ([self needBackToToday]) {
    //        [self backToToday];
    //    } else {
    //        [self.containerView setContentOffset:CGPointMake(([self.infiniteView middleIndex] + 1) * self.containerView.frame.size.width, 0) animated:YES];
    //    }
}

- (void)prePage {
    [self.infiniteView prePage];
    //    if ([self needBackToToday]) {
    //        [self backToToday];
    //    } else {
    //        [self.containerView setContentOffset:CGPointMake(([self middleIndex] - 1) * self.containerView.frame.size.width, 0) animated:YES];
    //    }
    
}

- (BOOL)needBackToToday {
    if (self.currentMonthDay == [CalendarUtil firstDayOfMonth:[CalendarUtil todayDateline]]) {
        return YES;
    }
    return NO;
}

- (void)backToToday {
    if (self.currentMode == ECalendarShowModeWeek) {
//        BOOL  isCrossWeek = [CalendarUtil i]
        NSInteger weekDayOfToday = [CalendarUtil weekdayOfDateline:[CalendarUtil todayDateline]];
        NSInteger foucusBeginDay = [CalendarUtil dateline:[CalendarUtil todayDateline] offsetByDay:-weekDayOfToday];
        NSInteger foucusEndDay = [CalendarUtil dateline:foucusBeginDay offsetByDay:7 - 1];
        
        BOOL isCrossWeek = self.currentDay > foucusEndDay || self.currentDay < foucusBeginDay;
        [self setCurrentMonth:[CalendarUtil todayDateline] day:[CalendarUtil todayDateline]];
        if (isCrossWeek) {
            [self reloadData];
        } else {
            [self reloadCurrent];
        }
    } else {
        BOOL isCrossMonth = self.currentMonthDay != [CalendarUtil firstDayOfMonth:[CalendarUtil todayDateline]];
        if (isCrossMonth) {
            [self setCurrentMonth:[CalendarUtil todayDateline] day:[CalendarUtil todayDateline]];
            [self reloadData];
        } else {
            self.currentDay = [CalendarUtil todayDateline];
            [self reloadCurrent];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:currentDateline:)]) {
        [self.delegate calendarView:self currentDateline:self.currentDay];
    }
}

- (void)setCurrentMonth:(NSInteger)currentMonthDay day:(NSInteger)currentDay {
    self.currentDay = currentDay;
    self.currentMonthDay = currentMonthDay;
}

- (void)setCurrentMonthDay:(NSInteger)currentMonthDay {
    _currentMonthDay = [CalendarUtil firstDayOfMonth:currentMonthDay];
}

- (NSInteger)currentMonthWithPageIndex:(NSInteger)pageIndex {
    return [CalendarUtil dateline:self.currentMonthDay offsetByMonth:pageIndex - [self.infiniteView middleIndex]];
}

#pragma mark calendar datasource

- (CalendarDayData *)calendarDataWithView:(CalendarPageBaseView *)calendarPageView dayOfIndex:(NSInteger)index {
    NSInteger pageIndex = [self.infiniteView indexOfPageView:calendarPageView];
    if (pageIndex != NSNotFound) {
        NSInteger currentMonth = [self currentMonthWithPageIndex:pageIndex];
        NSInteger dateline = 0;
        if (self.currentMode == ECalendarShowModeMonth) {
            dateline = [self datelineOfPageIndex:pageIndex dayIndex:index];
        } else {
            dateline = [self datelineOfWeekIndex:pageIndex dayIndex:index];
        }
        CalendarDayData *dayModel = [[CalendarDayData alloc] initWithDateline:dateline];
        dayModel.isActive = self.currentMode == ECalendarShowModeMonth ? [CalendarUtil firstDayOfMonth:dateline] == currentMonth : YES;
        dayModel.isToday = dateline == [CalendarUtil todayDateline];
        return dayModel;
    }
    return nil;
}



- (void)calendarDataView:(CalendarPageBaseView *)calendarPageView didselectedAtIndex:(NSInteger)index {
    NSInteger pageIndex = [self.infiniteView indexOfPageView:calendarPageView];
    NSInteger dateline = 0;
    
    if (self.currentMode == ECalendarShowModeWeek) {
        dateline = [self datelineOfWeekIndex:pageIndex dayIndex:index];
    } else {
        dateline = [self datelineOfPageIndex:pageIndex dayIndex:index];
    }
    
    if (dateline != self.currentDay) {
        self.currentDay = dateline;
        
        if ([CalendarUtil firstDayOfMonth:self.currentDay] != self.currentMonthDay) {
            self.crossSelectedDay = dateline;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:didSelectedDateline:)]) {
        [self.delegate calendarView:self didSelectedDateline:dateline];
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
