//
//  YAStackedBarChartDataSource.m
//  YACorePlotBlog
//
//  Created by Eugene Goloboyar on 25.12.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YALStackedBarChartDataSource.h"

//view
#import "YALStackedBarChartView.h"

//model
#import "YAStackedBarChartSectionDataSource.h"
#import "YAStackedBarChartObject.h"

@interface YALStackedBarChartDataSource () <YALStackedBarChartViewDataSource>

@property (nonatomic, strong) YAStackedBarChartSectionDataSource *sectionDataSource;

@end

@implementation YALStackedBarChartDataSource

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

- (NSInteger)numberOfSectionInStackedBarChartView:(YALStackedBarChartView *)stackedBarChartView {
    return [self.sectionDataSource numberOfSection];
}

- (NSInteger)stackedBarChartView:(YALStackedBarChartView *)stackedBarChartView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionDataSource numberOfRowsInSection:section];
}

- (CGFloat)stackedBarChartView:(YALStackedBarChartView *)stackedBarChartView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YAStackedBarChartObject *object = [self.sectionDataSource objectAtIndexPath:indexPath];
    return [object height];
}

- (UIColor *)stackedBarChartView:(YALStackedBarChartView *)stackedBarChartView colorForRowAtIndexPath:(NSIndexPath *)indexPath {
    YAStackedBarChartObject *object = [self.sectionDataSource objectAtIndexPath:indexPath];
    return [object color];
}

@end
