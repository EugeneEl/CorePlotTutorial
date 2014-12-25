//
//  YAStackedBarChartSection.h
//  YACorePlotBlog
//
//  Created by Eugene Goloboyar on 17.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YAStackedBarChartObject;

@interface YAStackedBarChartSection : NSObject

//init each section 
- (instancetype)initWithDate:(NSDate *)date inContext:(NSManagedObjectContext *)context;

- (NSUInteger)numberOfObjects;

- (YAStackedBarChartObject *)objectAtIndex:(NSInteger)index;

@end
