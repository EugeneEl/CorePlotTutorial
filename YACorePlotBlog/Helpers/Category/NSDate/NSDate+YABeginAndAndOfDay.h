//
//  NSDate+YABeginAndAndOfDay.h
//  YACorePlotBlog
//
//  Created by Евгений on 17.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YABeginAndAndOfDay)

- (NSDate *)ya_beginningOfDay;
- (NSDate *)ya_endOfDay;
- (NSDate *)ya_dateWithDaysAgo:(NSUInteger)days;

@end