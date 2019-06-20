//
//  CalendarDayCell.h
//  CalendarDemo
//
//  Created by John on 2019/5/7.
//  Copyright © 2019 John. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CalendarDayData;

NS_ASSUME_NONNULL_BEGIN

@interface CalendarDayCell : UICollectionViewCell

@property (nonatomic) BOOL isActivity;

@property (nonatomic) CalendarDayData *day;

- (void)bindDataModel:(CalendarDayData *)day;

@end

NS_ASSUME_NONNULL_END
