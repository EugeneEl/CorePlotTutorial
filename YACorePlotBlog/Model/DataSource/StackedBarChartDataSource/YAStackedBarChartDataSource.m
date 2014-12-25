//
//  YAStackedBarChartDataSource.m
//  YACorePlotBlog
//
//  Created by Eugene Goloboyar on 25.12.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YAStackedBarChartDataSource.h"

//view
#import "YAStackedBarChartView.h"

//model
#import "YAStackedBarChartSectionDataSource.h"
#import "YAStackedBarChartObject.h"

@interface YAStackedBarChartDataSource () <YAStackedBarChartViewDataSource>

@property (nonatomic, strong) YAStackedBarChartSectionDataSource *sectionDataSource;

@end

@implementation YAStackedBarChartDataSource

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _sectionDataSource = [YAStackedBarChartSectionDataSource
                              dataSourceForLast7DaysInContext:[NSManagedObjectContext MR_defaultContext]];
    }
    return self;
}

#pragma mark - YAStackedBarChartViewDataSource

- (NSInteger)numberOfSectionInStackedBarChartView:(YAStackedBarChartView *)stackedBarChartView {
    return [self.sectionDataSource numberOfSection];
}

- (NSInteger)stackedBarChartView:(YAStackedBarChartView *)stackedBarChartView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionDataSource numberOfRowsInSection:section];
}

- (CGFloat)stackedBarChartView:(YAStackedBarChartView *)stackedBarChartView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YAStackedBarChartObject *object = [self.sectionDataSource objectAtIndexPath:indexPath];
    return [object height];
}

- (UIColor *)stackedBarChartView:(YAStackedBarChartView *)stackedBarChartView colorForRowAtIndexPath:(NSIndexPath *)indexPath {
    YAStackedBarChartObject *object = [self.sectionDataSource objectAtIndexPath:indexPath];
    return [object color];
}

@end
