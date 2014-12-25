//
//  YABarChartViewDataSource.m
//  YACorePlotBlog
//
//  Created by Eugene Goloboyar on 25.12.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YABarChartViewDataSource.h"

//view
#import "YABarChartView.h"

//model
#import "YAExercise.h"

@interface YABarChartViewDataSource () <YABarChartViewDataSource>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation YABarChartViewDataSource

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

- (NSInteger)numberOfBarsInBarChartView:(YABarChartView *)barChartView {
    return  [self.fetchedResultsController.fetchedObjects count];
}

- (id <YABarChartProtocol>)barChartView:(YABarChartView *)barChartView barAtIndex:(NSInteger)index {
    return [self.fetchedResultsController.fetchedObjects objectAtIndex:index];
}

@end
