//
//  YAViewController.m
//  YACorePlotBlog
//
//  Created by Евгений on 15.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YABarChartViewController.h"

//model
#import "YAExercise.h"

//view
#import "YABarChartView.h"

@interface YABarChartViewController () <YABarChartViewDataSource>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation YABarChartViewController

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _fetchedResultsController = [YAExercise MR_fetchAllSortedBy:nil
                                                          ascending:NO
                                                      withPredicate:nil
                                                            groupBy:nil
                                                           delegate:nil
                                                          inContext:[NSManagedObjectContext MR_defaultContext]];
    }
    return self;
}

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", [YAExercise MR_findAll]);
}

#pragma mark - YABarChartViewDataSource

- (NSInteger)numberOfChartsInBarChartView:(YABarChartView *)barChartView {
    return  [self.fetchedResultsController.fetchedObjects count];
}

- (id <YABarChartProtocol>)barChartView:(YABarChartView *)barChartView plotAtIndex:(NSInteger)index {
    return [self.fetchedResultsController.fetchedObjects objectAtIndex:index];
}


@end
