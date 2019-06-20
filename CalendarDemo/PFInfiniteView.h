//
//  PFInfiniteView.h
//  CalendarDemo
//
//  Created by John on 2019/6/19.
//  Copyright © 2019 John. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PFInfiniteViewProtocol <NSObject>

- (UIView *)infinitePageView;
- (void)reloadData;

@end

@protocol PFInfiniteViewDatasource <NSObject>

- (id<PFInfiniteViewProtocol>)pageView;

@end

@class PFInfiniteView;

@protocol PFInfiniteViewDelegate <NSObject>

- (void)infiniteView:(PFInfiniteView *)infiniteView scrollToLeft:(BOOL)isLeft;
- (void)infiniteView:(PFInfiniteView *)infiniteView atIndex:(NSInteger)index;
- (void)infiniteViewEndScroll:(PFInfiniteView *)infiniteView;
- (void)infiniteViewBeginScroll:(PFInfiniteView *)infiniteView;

@end

@interface PFInfiniteView : UIView

@property (nonatomic, weak)id<PFInfiniteViewDatasource> datasource;
@property (nonatomic, weak)id<PFInfiniteViewDelegate> delegate;


- (NSInteger)middleIndex;

- (void)reloadData;
- (void)nextPage;
- (void)prePage;

- (NSInteger)indexOfPageView:(id<PFInfiniteViewProtocol>)pageView;
-(id<PFInfiniteViewProtocol>)pageOfIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
