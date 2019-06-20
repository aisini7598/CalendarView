//
//  CalendarPageBaseView.m
//  CalendarDemo
//
//  Created by John on 2019/6/18.
//  Copyright © 2019 John. All rights reserved.
//

#import "CalendarPageBaseView.h"
#import "CalendarDayCell.h"
#import "CalendarDayData.h"
#import "CalendarPageViewData.h"


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



CGFloat minimumLineSpacing = 5;

static NSString *const KCalendarCellIdentifire = @"calendarIdentifire";

@interface CalendarPageBaseView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak) UICollectionView *monthPageView;
@property (nonatomic) CalendarPageViewData *viewModel;

@property (nonatomic, copy) NSArray *datas;

@end

@implementation CalendarPageBaseView

- (instancetype)initWithViewModel:(CalendarPageViewData *)viewModel {
    self = [super init];
    if (self) {
        [self updateViewModel:viewModel];
    }
    
    return self;
}

- (void)updateViewModel:(CalendarPageViewData *)viewModel {
    _viewModel = viewModel;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = minimumLineSpacing;
    layout.minimumInteritemSpacing = minimumLineSpacing;
    
    UICollectionView *monthPageView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    monthPageView.delegate = self;
    monthPageView.dataSource = self;
    monthPageView.showsHorizontalScrollIndicator = NO;
    monthPageView.showsVerticalScrollIndicator = NO;
    monthPageView.backgroundColor = [UIColor clearColor];
    monthPageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:monthPageView];
    self.monthPageView = monthPageView;
    [monthPageView registerClass:CalendarDayCell.class forCellWithReuseIdentifier:KCalendarCellIdentifire];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self rowOfNumber] * [self columnOfNumber];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (collectionView.bounds.size.width - ([self columnOfNumber] - 1) * minimumLineSpacing) / [self columnOfNumber];
    CGFloat height = (collectionView.bounds.size.height - ([self rowOfNumber] - 1) * minimumLineSpacing) / [self rowOfNumber];
    
    return CGSizeMake(width, height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CalendarDayCell *dayCell = [collectionView dequeueReusableCellWithReuseIdentifier:KCalendarCellIdentifire forIndexPath:indexPath];
    dayCell.selected = NO;
    dayCell.backgroundColor = [UIColor whiteColor];
    if (self.viewModel.dataSource && [self.viewModel.dataSource respondsToSelector:@selector(calendarDataWithView:dayOfIndex:)]) {
        [dayCell bindDataModel:[self.viewModel.dataSource calendarDataWithView:self dayOfIndex:indexPath.row]];
    }
    return dayCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.delegate && [self.viewModel.delegate respondsToSelector:@selector(calendarDataView:didselectedAtIndex:)]) {
        [self.viewModel.delegate calendarDataView:self didselectedAtIndex:indexPath.row];
    }
}

- (void)reloadData {
    [self.monthPageView reloadData];
}

- (void)selectedIndex:(NSInteger)index {
    
    [self.monthPageView performBatchUpdates:^{
        
    } completion:^(BOOL finished) {
        [self.monthPageView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        
    }];
}

- (void)setWeekCoverView:(UIView *)weekCoverView {
    _weekCoverView = weekCoverView;
    [self addSubview:weekCoverView];
}


- (NSInteger)rowOfNumber {
    return 1;
}
- (NSInteger)columnOfNumber {
    return 1;
}

- (UIView *)infinitePageView {
    return self;
}

@end
