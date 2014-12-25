//
//  YAPieChartViewDataSource.m
//  YACorePlotBlog
//
//  Created by Eugene Goloboyar on 25.12.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YAPieChartViewDataSource.h"

//view
#import "YAPieChartView.h"

//model
#import "YAExercise.h"

@interface YAPieChartViewDataSource () <YAPieChartViewDataSource>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation YAPieChartViewDataSource

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

#pragma mark - YAPieChartViewDataSource

- (NSInteger)numberOfSectorsInPieChartView:(YAPieChartView *)pieChartView{
    return  [self.fetchedResultsController.fetchedObjects count];
}

- (id <YAPieChartProtocol>)pieChartView:(YAPieChartView *)pieChartView sectorAtIndex:(NSInteger)index {
    return [self.fetchedResultsController.fetchedObjects objectAtIndex:index];
}


@end
