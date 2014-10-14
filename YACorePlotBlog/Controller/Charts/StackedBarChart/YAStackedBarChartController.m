//
//  YAStackedBarChartController.m
//  YACorePlotBlog
//
//  Created by Евгений on 17.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YAStackedBarChartController.h"

//model
#import "YAStackedBarChartObject.h"
#import "YAStackedBarChartSectionDataSource.h"

//view
#import "YAStackedBarChartView.h"

@interface YAStackedBarChartController () <YAStackedBarChartViewDataSource>

@property (nonatomic, weak) IBOutlet YAStackedBarChartView *view;

@property (nonatomic, strong) YAStackedBarChartSectionDataSource *dataSource;

@end

@implementation YAStackedBarChartController

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _dataSource = [YAStackedBarChartSectionDataSource
                       dataSourceForLast7DaysInContext:[NSManagedObjectContext MR_defaultContext]];
    }
    return self;
}

#pragma mark - View & LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dataSource = self;
}

#pragma mark - YAStackedBarChartViewDataSource

- (NSInteger)numberOfSectionInStackedBarChartView:(YAStackedBarChartView *)stackedBarChartView {
    return [self.dataSource numberOfSection];
}

- (NSInteger)stackedBarChartView:(YAStackedBarChartView *)stackedBarChartView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfRowsInSection:section];
}

- (CGFloat)stackedBarChartView:(YAStackedBarChartView *)stackedBarChartView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YAStackedBarChartObject *object = [self.dataSource objectAtIndexPath:indexPath];
    return [object height];
}

- (UIColor *)stackedBarChartView:(YAStackedBarChartView *)stackedBarChartView colorForRowAtIndexPath:(NSIndexPath *)indexPath {
    YAStackedBarChartObject *object = [self.dataSource objectAtIndexPath:indexPath];
    return [object color];
}

@end
