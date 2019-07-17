//
//  PFInfiniteView.m
//  CalendarDemo
//
//  Created by John on 2019/6/19.
//  Copyright © 2019 John. All rights reserved.
//

#import "PFInfiniteView.h"

NSInteger infinitePageCount = 3;

@interface PFInfiniteView ()<UIScrollViewDelegate>

@property (nonatomic, copy) NSArray *pageViews;
@property (nonatomic, weak) UIScrollView *infiniteContainer;

@property (nonatomic) CGFloat lastOffsetX;

@end

@implementation PFInfiniteView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _allowInfinite = YES;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UIScrollView *containerView = [[UIScrollView alloc] initWithFrame:self.bounds];
    containerView.pagingEnabled = YES;
    containerView.delegate = self;
    containerView.showsHorizontalScrollIndicator = NO;
    containerView.clipsToBounds = NO;
    containerView.bounces = NO;
    [self addSubview:containerView];
    _infiniteContainer = containerView;
}

- (void)setDatasource:(id<PFInfiniteViewDatasource>)datasource {
    _datasource = datasource;
    [self initPageViews];
}

- (void)initPageViews {
    NSMutableArray *pageViews = NSMutableArray.array;
    for (NSUInteger i = 0; i < infinitePageCount; i++) {
        if (self.datasource && [self.datasource respondsToSelector:@selector(pageView)]) {
            id<PFInfiniteViewProtocol> infinitePage = [self.datasource pageView];
            UIView *infiniteView = [infinitePage infinitePageView];
            [self.infiniteContainer addSubview:infiniteView];
            [pageViews addObject:infinitePage];
        }
    }
    self.pageViews = pageViews.copy;
    self.infiniteContainer.contentSize = CGSizeMake(self.pageViews.count * self.infiniteContainer.frame.size.width, self.infiniteContainer.frame.size.height);
    
    [self resetInfinitePageFrame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self resetInfinitePageFrame];
}

- (void)resetInfinitePageFrame {
    if (self.pageViews.count == 0) {
        return;
    }
    
    for (NSUInteger i = 0; i < infinitePageCount; i++) {
         id<PFInfiniteViewProtocol> infinitePage = self.pageViews[i];
        [infinitePage infinitePageView].frame = CGRectMake(i * CGRectGetWidth(self.infiniteContainer.frame), 0, CGRectGetWidth(self.infiniteContainer.frame), CGRectGetHeight(self.infiniteContainer.frame));
    }
    
}

- (void)scrollToLeft:(BOOL)isLeft {
    id<PFInfiniteViewProtocol> infinitePage = nil;
    NSMutableArray *infiniteViews = self.pageViews.mutableCopy;
    if (!isLeft) {
        infinitePage =  infiniteViews.lastObject;
        [infiniteViews removeLastObject];
        [infiniteViews insertObject:infinitePage atIndex:0];
    } else {
        infinitePage = infiniteViews.firstObject;
        [infiniteViews removeObjectAtIndex:0];
        [infiniteViews addObject:infinitePage];
    }
    self.pageViews = infiniteViews.copy;
//    [infinitePage reloadData];
    [self resetInfinitePageFrame];
}

#pragma public method

- (void)reloadData {
    [self.infiniteContainer setContentOffset:CGPointMake(self.infiniteContainer.frame.size.width * [self middleIndex], 0) animated:YES];
    [self p_reloadPageView];
}

- (NSInteger)middleIndex {
    return ceil(infinitePageCount / 2);
}

- (NSInteger)indexOfPageView:(id<PFInfiniteViewProtocol>)pageView {
    return [self.pageViews indexOfObject:pageView];
}

-(id<PFInfiniteViewProtocol>)pageOfIndex:(NSInteger)index {
    return [self.pageViews objectAtIndex:index];
}

- (void)nextPage {
    [self.infiniteContainer setContentOffset:CGPointMake(([self middleIndex] + 1) * CGRectGetWidth(self.infiniteContainer.frame), 0) animated:YES];
}

- (void)prePage {
    [self.infiniteContainer setContentOffset:CGPointMake(([self middleIndex] - 1) * CGRectGetWidth(self.infiniteContainer.frame), 0) animated:YES];
    
}

#pragma scrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = floor((scrollView.contentOffset.x + scrollView.frame.size.width / 2) / scrollView.frame.size.width);
    if (index != [self middleIndex]) {
        BOOL isLeft = YES;
        if (index < [self middleIndex]) {
            isLeft = NO;
        }
        [self scrollToLeft:isLeft];
        if (self.delegate && [self.delegate respondsToSelector:@selector(infiniteView:scrollToLeft:)]) {
            [self.delegate infiniteView:self scrollToLeft:isLeft];
        }
        
        scrollView.contentOffset = CGPointMake([self middleIndex] * scrollView.frame.size.width, 0);
    }
    [self p_reloadPageView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(infiniteViewEndScroll:)]) {
        [self.delegate infiniteViewEndScroll:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(infiniteViewBeginScroll:)]) {
        [self.delegate infiniteViewBeginScroll:self];
    }
    _lastOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)p_reloadPageView {
    for (NSInteger i = 0; i < infinitePageCount; i++) {
        NSInteger index = ([self middleIndex] + i) % infinitePageCount;
        if (self.delegate && [self.delegate respondsToSelector:@selector(infiniteView:atIndex:)]) {
            [self.delegate infiniteView:self atIndex:index];
        }
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
