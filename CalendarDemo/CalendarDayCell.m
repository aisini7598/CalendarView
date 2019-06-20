//
//  CalendarDayCell.m
//  CalendarDemo
//
//  Created by John on 2019/5/7.
//  Copyright © 2019 John. All rights reserved.
//

#import "CalendarDayCell.h"
#import "CalendarDayData.h"

CGFloat animationDuration = 0.25;

@interface CalendarDayCell ()

@property (nonatomic, weak) UILabel *dayLabel;
@property (nonatomic, weak) UIView *animationBackgroudView;
@property (nonatomic, weak) UIImageView *finishImageView;

@property (nonatomic, weak) UIView *bottomView;

@end

@implementation CalendarDayCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    UIView *animationBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    animationBackgroundView.backgroundColor = UIColor.blueColor;
    [self.contentView addSubview:animationBackgroundView];
    _animationBackgroudView = animationBackgroundView;
    
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    dayLabel.backgroundColor = [UIColor clearColor];
    dayLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    dayLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:dayLabel];
    
    _dayLabel = dayLabel;

}

- (void)bindDataModel:(CalendarDayData *)day {
    _day = day;
    self.dayLabel.text = @(day.day).stringValue;
    if (day.isToday) {
        self.dayLabel.text = @"今";
    }
    self.isActivity = day.isActive;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    
    [self.dayLabel sizeToFit];
    self.dayLabel.center = self.contentView.center;
    
    self.animationBackgroudView.frame = self.contentView.bounds;
    
}

- (void)setIsActivity:(BOOL)isActivity {
    _isActivity = isActivity;
    if (_isActivity) {
        self.dayLabel.textColor = [UIColor blackColor];
    } else {
        self.dayLabel.textColor = [UIColor greenColor];
    }
//    self.dayLabel.hidden = !_isActivity;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        [self showAnimation];
    } else {
        [self hideAnimation];
    }
    [super setSelected:selected];
}

- (void)showAnimation {
    self.animationBackgroudView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:animationDuration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.animationBackgroudView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.animationBackgroudView.alpha = 1;
    } completion:^(BOOL finished) {
        self.animationBackgroudView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideAnimation {
    [UIView animateWithDuration:animationDuration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.animationBackgroudView.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

@end
