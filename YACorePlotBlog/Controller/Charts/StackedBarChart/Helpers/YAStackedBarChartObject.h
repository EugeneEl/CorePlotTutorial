//
//  YAStackedBarChartObject.h
//  YACorePlotBlog
//
//  Created by Евгений on 17.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YAExercise;

@interface YAStackedBarChartObject : NSObject

//each stackedBarChartObject represents set for specific exercise
//More that one set can be done per day

- (instancetype)initWithDate:(NSDate *)date exercise:(YAExercise *)exercise;

//we collect all exercises for some date (section) 
+ (NSArray *)arrayWithDate:(NSDate *)date exercises:(NSArray *)exercises;

//any stackedBarChartObject can return its color and height
- (CGFloat)height;
- (UIColor *)color;

@end
