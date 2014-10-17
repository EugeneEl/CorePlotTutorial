//
//  YAPieChartView.h
//  YACorePlotBlog
//
//  Created by Евгений on 16.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <CorePlot/CorePlot-CocoaTouch.h>
#import "YAPieChartProtocol.h"
@class YAPieChartView;


//protocol for our public datasource
@protocol YAPieChartViewDataSource <NSObject>

- (NSInteger)numberOfChartsInPieChartView:(YAPieChartView *)pieChartView;
- (id <YAPieChartProtocol>)pieChartView:(YAPieChartView *)pieChartView plotAtIndex:(NSInteger)index;

@end

@interface YAPieChartView: CPTGraphHostingView

@property (nonatomic, weak) IBOutlet id <YAPieChartViewDataSource> dataSource;

- (void)reloadData;

@end
