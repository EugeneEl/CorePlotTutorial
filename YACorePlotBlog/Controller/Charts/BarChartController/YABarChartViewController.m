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

@interface YABarChartViewController () <YABarChartViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet YABarChartView* view;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation YABarChartViewController

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _fetchedResultsController = [YAExercise MR_fetchAllSortedBy:@"name"
                                                          ascending:NO
                                                      withPredicate:nil
                                                            groupBy:nil
                                                           delegate:self
                                                          inContext:[NSManagedObjectContext MR_defaultContext]];
    }
    return self;
}

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //customize your chart basic design here
    self.view.barWidth = 5.f;
    self.view.distanceBetweenBars = 5.f;
    
    NSLog(@"%@", [YAExercise MR_findAll]);
}

#pragma mark - YABarChartViewDataSource

- (NSInteger)numberOfBarsInBarChartView:(YABarChartView *)barChartView {
    return  [self.fetchedResultsController.fetchedObjects count];
}

- (id <YABarChartProtocol>)barChartView:(YABarChartView *)barChartView barAtIndex:(NSInteger)index {
    return [self.fetchedResultsController.fetchedObjects objectAtIndex:index];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.view reloadData];
}

@end
