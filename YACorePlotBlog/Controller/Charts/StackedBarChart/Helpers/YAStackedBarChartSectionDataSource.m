//
//  YAStackedBarChartSectionDataSource.m
//  YACorePlotBlog
//
//  Created by Евгений on 17.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YAStackedBarChartSectionDataSource.h"

//model
#import "YAStackedBarChartObject.h"
#import "YAStackedBarChartSection.h"

//category
#import "NSDate+YABeginAndAndOfDay.h"

@interface YAStackedBarChartSectionDataSource ()

@property (nonatomic, strong) NSArray *sections;

@end

@implementation YAStackedBarChartSectionDataSource

#pragma mark - Initialization

- (instancetype)initWithDates:(NSArray *)dates inContext:(NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        NSMutableArray *mutableSectionArray = [NSMutableArray array];
        for (NSDate *date in dates) {
            YAStackedBarChartSection *section = [[YAStackedBarChartSection alloc] initWithDate:date inContext:context];
            [mutableSectionArray addObject:section];
        }
        
        _sections = [mutableSectionArray copy];
    }
    return self;
}

+ (instancetype)dataSourceForLast7DaysInContext:(NSManagedObjectContext *)context {
    // TODO: Please, refactor this method!
    NSMutableArray *dates = [NSMutableArray array];
    NSDate *today = [NSDate date];
    
    [dates addObject:[today ya_dateWithDaysAgo:6]];
    [dates addObject:[today ya_dateWithDaysAgo:5]];
    [dates addObject:[today ya_dateWithDaysAgo:4]];
    [dates addObject:[today ya_dateWithDaysAgo:3]];
    [dates addObject:[today ya_dateWithDaysAgo:2]];
    [dates addObject:[today ya_dateWithDaysAgo:1]];
    [dates addObject:today];
    
    return [[self alloc] initWithDates:[dates copy] inContext:context];
}

#pragma mark - Public

- (NSInteger)numberOfSection {
    return [self.sections count];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    YAStackedBarChartSection *sectionObject = self.sections[section];
    return [sectionObject numberOfObjects];
}

- (YAStackedBarChartObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    YAStackedBarChartSection *sectionObject = self.sections[indexPath.section];
    return [sectionObject objectAtIndex:indexPath.row];
}

@end
