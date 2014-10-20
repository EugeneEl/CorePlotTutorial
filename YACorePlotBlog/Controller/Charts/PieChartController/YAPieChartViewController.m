//
//  YAPieChartViewController.m
//  YACorePlotBlog
//
//  Created by Евгений on 16.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YAPieChartViewController.h"

//model
#import "YAExercise.h"

//view
#import "YAPieChartView.h"

@interface YAPieChartViewController () <YAPieChartViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet YAPieChartView* view;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation YAPieChartViewController

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
    
    //customize your chart here, but do not forget about sizes of your view
    self.view.pieRadius = 80.f;
    self.view.pieInnerCornerRadius = 0.f;
    NSLog(@"%@", [YAExercise MR_findAll]);
}

#pragma mark - YABarChartViewDataSource

- (NSInteger)numberOfSectorsInPieChartView:(YAPieChartView *)pieChartView{
    return  [self.fetchedResultsController.fetchedObjects count];
}

- (id <YAPieChartProtocol>)pieChartView:(YAPieChartView *)pieChartView sectorAtIndex:(NSInteger)index {
    return [self.fetchedResultsController.fetchedObjects objectAtIndex:index];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.view reloadData];
}


@end
