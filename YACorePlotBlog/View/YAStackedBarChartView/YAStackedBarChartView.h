//
//  YAStackedBarChartView.h
//  YACorePlotBlog
//
//  Created by Евгений on 17.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <CorePlot/CorePlot-CocoaTouch.h>

typedef struct {
    CGFloat top;
    CGFloat right;
    CGFloat bottom;
    CGFloat left;
} YAPaddingInset;

@class YAStackedBarChartView;

//protocol for out public datasource
@protocol YAStackedBarChartViewDataSource <NSObject>

- (NSInteger)numberOfSectionInStackedBarChartView:(YAStackedBarChartView *)stackedBarChartView;
- (NSInteger)stackedBarChartView:(YAStackedBarChartView *)stackedBarChartView numberOfRowsInSection:(NSInteger)section;

- (CGFloat)stackedBarChartView:(YAStackedBarChartView *)stackedBarChartView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIColor *)stackedBarChartView:(YAStackedBarChartView *)stackedBarChartView colorForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface YAStackedBarChartView : CPTGraphHostingView

- (void)reloadData;

@property (nonatomic, weak) IBOutlet id <YAStackedBarChartViewDataSource> dataSource;

@property (nonatomic, assign) CGFloat sectionWidth;
@property (nonatomic, assign) CGFloat distanceBetweenBars;
@property (nonatomic, assign) CGFloat offsetFromLeft;
@property (nonatomic, assign) CGFloat offsetFromRight;
@property (nonatomic, assign) YAPaddingInset paddingInset;

@end
