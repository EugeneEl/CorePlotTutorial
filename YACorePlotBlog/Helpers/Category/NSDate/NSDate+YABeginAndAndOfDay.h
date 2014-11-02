//
//  NSDate+YABeginAndAndOfDay.h
//  YACorePlotBlog
//
//  Created by Eugene Goloboyar on 17.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSDate (YABeginAndAndOfDay)

+ (NSDate *)ya_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
- (NSDate *)ya_beginningOfDay;
- (NSDate *)ya_endOfDay;
- (NSDate *)ya_dateWithDaysAgo:(NSUInteger)days;

@end
