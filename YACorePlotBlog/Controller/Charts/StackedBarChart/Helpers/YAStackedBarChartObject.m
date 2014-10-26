//
//  YAStackedBarChartObject.m
//  YACorePlotBlog
//
//  Created by Eugene Goloboyar on 17.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YAStackedBarChartObject.h"

//model
#import "YAExercise.h"
#import "YASet.h"

//category
#import "NSDate+YABeginAndAndOfDay.h"
#import "UIColor+YAColorWithHexString.h"

@interface YAStackedBarChartObject ()

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) YAExercise *exercise;

@end

@implementation YAStackedBarChartObject

#pragma mark - Initialization

- (instancetype)initWithDate:(NSDate *)date exercise:(YAExercise *)exercise {
    self = [super init];
    if (self) {
        _date = date;
        _exercise = exercise;
    }
    return self;
}

+ (NSArray *)arrayWithDate:(NSDate *)date exercises:(NSArray *)exercises {
    NSMutableArray *array = [NSMutableArray array];
    for (YAExercise *exercise in exercises) {
        YAStackedBarChartObject *object = [[self alloc] initWithDate:date exercise:exercise];
        [array addObject:object];
    }
    return [array copy];
}

#pragma mark - Public

//calculated height for each stackedBarChartObject
//total height equals to sum of all reps for exercise done on specific date
- (CGFloat)height {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doneAt >= %@ AND doneAt < %@", [self.date ya_beginningOfDay], [self.date ya_endOfDay]];
    NSSet *exerciseSets = [self.exercise.sets filteredSetUsingPredicate:predicate];
    NSNumber *setsRepTotalCount = [exerciseSets valueForKeyPath:@"@sum.repCount"];
    return [setsRepTotalCount floatValue];
}

//each stackedBarChartObject can return its color
- (UIColor *)color {
    return [UIColor ya_colorFromHexString:self.exercise.colorHexName];
}

@end
