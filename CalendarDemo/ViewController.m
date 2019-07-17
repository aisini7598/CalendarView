//
//  ViewController.m
//  CalendarDemo
//
//  Created by John on 2019/5/6.
//  Copyright © 2019 John. All rights reserved.
//

#import "ViewController.h"
#import "CalendarView.h"

#import "CalendarUtil.h"

@interface ViewController ()<CalendarViewDelegate>

@property (nonatomic, weak) CalendarView *calendarView;
@property (nonatomic, weak) UIButton *indicatorButton;
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation ViewController

- (void)loadView {
    [super loadView];
    UIButton *indicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [indicatorButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    indicatorButton.bounds = CGRectMake(0, 0, 44, 44);
    [indicatorButton addTarget:self action:@selector(changeMonthPage) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = UIColor.blackColor;
    self.titleLabel = titleLabel;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [titleView addSubview:titleLabel];
    [titleView addSubview:indicatorButton];
    
    self.navigationItem.titleView = titleView;
    self.indicatorButton = indicatorButton;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CalendarView *calendarView = [[CalendarView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 300)];
    calendarView.currentMode = ECalendarShowModeWeek;
    
    [self.view addSubview:calendarView];
//    calendarView.currentDay = [CalendarUtil todayDateline];
    [calendarView setCurrentMonth:[CalendarUtil todayDateline] day:[CalendarUtil todayDateline]];
    calendarView.delegate = self;
    
    _calendarView = calendarView;
    
    [calendarView reloadData];
    
    
    // Do any additional setup after loading the view.
}


- (void)calendarView:(CalendarView *)calendarView currentDateline:(NSInteger)dateline {
    [self updateTitleView:dateline];
    
}

- (void)calendarView:(CalendarView *)calendarView didSelectedDateline:(NSInteger)dateline {
    [self updateTitleView:dateline];
}

- (void)updateTitleView:(NSInteger)dateline {
    NSInteger year = dateline / 10000;
    NSInteger month = (dateline / 100) % 100;
    NSInteger day = dateline % 100;
    NSString *title = [NSString stringWithFormat:@"%04ld年%02ld月%02ld日",year,month,day];
    self.titleLabel.text = title;
    self.indicatorButton.hidden = (dateline == [CalendarUtil todayDateline]);
    if (dateline != [CalendarUtil todayDateline]) {
        [self.indicatorButton setTitle:@"今" forState:UIControlStateNormal];
    }
    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(0, (self.navigationItem.titleView.frame.size.height - CGRectGetHeight(self.titleLabel.frame)) / 2, CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.titleLabel.frame));
    self.indicatorButton.bounds = CGRectMake(0, 0, 44, 44);
    self.indicatorButton.center = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + 22, self.titleLabel.center.y);
    self.navigationItem.titleView.frame = CGRectMake(0, 0, CGRectGetMaxX(self.indicatorButton.frame), 44);
    
}

- (void)changeMonthPage {
    [self.calendarView backToToday];
    
}

@end
