//
//  YABarChartViewDataSource.m
//  YACorePlotBlog
//
//  Created by Eugene Goloboyar on 25.12.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YALBarChartViewDataSource.h"

//view
#import "YALBarChartView.h"

//model
#import "YAExercise.h"

@interface YALBarChartViewDataSource () <YABarChartViewDataSource>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation YALBarChartViewDataSource

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _fetchedResultsController = [YAExercise MR_fetchAllSortedBy:@"name"
                                                          ascending:NO
                                                      withPredicate:nil
                                                            groupBy:nil
                                                           delegate:nil
                                                          inContext:[NSManagedObjectContext MR_defaultContext]];
    }
    return self;
}

#pragma mark - YABarChartViewDataSource

- (NSInteger)numberOfBarsInBarChartView:(YALBarChartView *)barChartView {
    return  [self.fetchedResultsController.fetchedObjects count];
}

- (id <YABarChartProtocol>)barChartView:(YALBarChartView *)barChartView barAtIndex:(NSInteger)index {
    return [self.fetchedResultsController.fetchedObjects objectAtIndex:index];
}

@end
