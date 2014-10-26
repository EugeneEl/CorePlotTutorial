//
//  NSDate+YABeginAndAndOfDay.m
//  YACorePlotBlog
//
//  Created by Eugene Goloboyar on 17.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "NSDate+YABeginAndAndOfDay.h"

@implementation NSDate (YABeginAndAndOfDay)

// https://github.com/mattt/CupertinoYankee
// Thank you, Mattt!
- (NSDate *)ya_beginningOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                               fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)ya_endOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    
    return [[calendar dateByAddingComponents:components toDate:[self ya_beginningOfDay] options:0]
            dateByAddingTimeInterval:-1];
}

- (NSDate *)ya_dateWithDaysAgo:(NSUInteger)days {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-days];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

@end
