//
//  YAStackedBarChartSectionDataSource.h
//  YACorePlotBlog
//
//  Created by Евгений on 17.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YAStackedBarChartObject;

@interface YAStackedBarChartSectionDataSource : NSObject

+ (instancetype)dataSourceForLast7DaysInContext:(NSManagedObjectContext *)context;

- (NSInteger)numberOfSection;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (YAStackedBarChartObject *)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
