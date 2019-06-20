//
//  CalendarPageBaseView.h
//  CalendarDemo
//
//  Created by John on 2019/6/18.
//  Copyright © 2019 John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFInfiniteView.h"

NS_ASSUME_NONNULL_BEGIN

@class CalendarPageViewData;

@interface CalendarPageBaseView : UIView<PFInfiniteViewProtocol>

- (instancetype)initWithViewModel:(CalendarPageViewData *)viewModel;

@property (nonatomic, readonly) CalendarPageViewData *viewModel;

@property (nonatomic) UIView *weekCoverView;

- (void)selectedIndex:(NSInteger)index;

- (NSInteger)rowOfNumber;
- (NSInteger)columnOfNumber;



@end

NS_ASSUME_NONNULL_END
