//
//  YAStackedBarChartView.m
//  YACorePlotBlog
//
//  Created by Евгений on 17.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YAStackedBarChartView.h"

static CGFloat const kAxisXLabelTextFontSize = 12.0f;
static CGFloat const kLineWidth = 1.0f;
static CGFloat const kNumberOfTicksAtXAxes = 12.f;
static CGFloat const kMultiplierForMimimalBarValue = 0.03f;

@interface YAStackedBarChartView ()

@property (nonatomic, strong) CPTXYGraph *graph;
@property (nonatomic, assign) NSInteger *numberOfRecords;
@property (nonatomic, assign) CGFloat defaultMinimalHegiht;

@end

@implementation YAStackedBarChartView

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Private

- (void)commonInit {
    self.graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    [self setHostedGraph:self.graph];
    
    [self.graph setValue:@(0.f) forKey:@"paddingLeft"];
    [self.graph setValue:@(0.f) forKey:@"paddingTop"];
    [self.graph setValue:@(0.f) forKey:@"paddingRight"];
    [self.graph setValue:@(0.f) forKey:@"paddingBottom"];
    
    // setup
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor whiteColor];
    borderLineStyle.lineWidth = 2.0f;
    self.graph.plotAreaFrame.borderLineStyle = borderLineStyle;
    self.graph.plotAreaFrame.paddingTop = 10.0;
    self.graph.plotAreaFrame.paddingRight = 10.0;
    self.graph.plotAreaFrame.paddingBottom = 20.0;
    self.graph.plotAreaFrame.paddingLeft = 40.0;
    
    //set axes' line styles and interval ticks
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    gridLineStyle.lineWidth = kLineWidth;
    
    //setup style for label for Y axis
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = kAxisXLabelTextFontSize;
   
    
    //Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    
    //setup format for x labels axes
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setGeneratesDecimalNumbers:TRUE];
    
    //X axis
    CPTXYAxis *x = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    x.axisLineStyle = gridLineStyle;
    
    //Y axis
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    y.majorGridLineStyle = gridLineStyle;
    y.minorTickLineStyle = gridLineStyle;
    y.majorTickLineStyle = gridLineStyle;
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    y.labelTextStyle = textStyle;
    y.axisLineStyle = gridLineStyle;
    y.minorTicksPerInterval = 5;
    y.labelFormatter = formatter;
}

#pragma mark - Public

- (void)reloadData {
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    
    // Remove previous plots
    [[self.graph allPlots] enumerateObjectsUsingBlock:^(CPTPlot *plot, NSUInteger idx, BOOL *stop) {
        [self.graph removePlot:plot];
    }];
    
    // Add new plots
    NSInteger numberOfSection = [self.dataSource numberOfSectionInStackedBarChartView:self];
    for (NSInteger section = 0; section < numberOfSection; section++) {
        NSInteger numberOfRows = [self.dataSource stackedBarChartView:self numberOfRowsInSection:section];
        for (NSInteger row = 0; row < numberOfRows; row++) {
            // Create plot
            CPTBarPlot *plot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor yellowColor] horizontalBars:NO];
            
            // Setup plot
            CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
            borderLineStyle.lineColor = [CPTColor whiteColor];
            borderLineStyle.lineWidth = [@0.5 floatValue];
            plot.lineStyle = borderLineStyle;
            plot.barWidth = CPTDecimalFromCGFloat(self.sectionWidth);
            plot.dataSource = self;
            
            //if current plot is first in section - barBasesVary = NO
            //If NO, a constant base value is used for all bars. If YES, the data source is queried to supply a base value for each bar.
            //The coordinate value of the fixed end of the bars.
            plot.barBasesVary = index == 0 ? NO : YES;
            plot.barCornerRadius = [@0 floatValue];
            
            //provide our plot with identifier - for this we made all staff with sections and objects
            //we can work with each plot as with row in table view, but placed into section.
            plot.identifier = [NSIndexPath indexPathForRow:row inSection:section];
            [self.graph addPlot:plot toPlotSpace:plotSpace];
        }
    }
    
    // Calculate XY ranges
    
    //calculating real data - real height
    CGFloat maxHeight = 0.f;
    for (NSInteger section = 0; section < numberOfSection; section++) {
        NSInteger numberOfRows = [self.dataSource stackedBarChartView:self numberOfRowsInSection:section];
        CGFloat sectionHeight = 0.f;
        for (NSInteger row = 0; row < numberOfRows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            sectionHeight += [self.dataSource stackedBarChartView:self heightForRowAtIndexPath:indexPath];
        }
        maxHeight = fmaxf(maxHeight, sectionHeight);
    }
    
    self.defaultMinimalHegiht = maxHeight * kMultiplierForMimimalBarValue;
    
    // TODO: Refactor dual loops
    maxHeight = 0.f;
    
    for (NSInteger section = 0; section < numberOfSection; section++) {
        NSInteger numberOfRows = [self.dataSource stackedBarChartView:self numberOfRowsInSection:section];
        CGFloat sectionHeight = 0.f;
        for (NSInteger row = 0; row < numberOfRows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            
            //
            sectionHeight += [self heightForRowAtIndexPath:indexPath];
        }
        maxHeight = fmaxf(maxHeight, sectionHeight);
    }
    
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[@0 decimalValue] length:[@(maxHeight+5.f) decimalValue]];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[@0 decimalValue] length:[@(242) decimalValue]];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    if (maxHeight > 12.0f) {
        float intervalLength = maxHeight / kNumberOfTicksAtXAxes;
        axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat(ceilf(intervalLength));
        
    } else if (maxHeight == 0) {
        axisSet.yAxis.majorGridLineStyle = nil;
    }
    
    [self.graph reloadData];
}

#pragma mark - CPTPlotDataSource

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 1;
}

- (NSNumber *)numberForPlot:(CPTBarPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)recordIndex {
    NSIndexPath *indexPath = (NSIndexPath *)plot.identifier;
    
    // X Value
    if (fieldEnum == CPTBarPlotFieldBarLocation) {
        return @(((indexPath.section) * (self.sectionWidth+self.distanceBetweenBars) + (self.sectionWidth/2)) + self.offsetFromLeft);
        
        // Y Value
    } else if (fieldEnum == CPTBarPlotFieldBarTip)  {
        CGFloat offset = 0;
        for (NSInteger row = 0; row < indexPath.row; row++) {
            offset += [self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
        }
        return @([self heightForRowAtIndexPath:indexPath] + offset);
        
        // Offset
    } else if (fieldEnum == CPTBarPlotFieldBarBase) {
        CGFloat offset = 0;
        for (NSInteger row = 0; row < indexPath.row; row++) {
            offset += [self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
        }
        
        return @(offset);
    } else {
        return nil;
    }
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [self.dataSource stackedBarChartView:self heightForRowAtIndexPath:indexPath];
    
    if (height > self.defaultMinimalHegiht) {
        return height;
    } else {
        return self.defaultMinimalHegiht;
    }
    
    return height;
}

#pragma mark - CPTBarPlotDataSource

- (CPTFill *)barFillForBarPlot:(CPTBarPlot *)plot recordIndex:(NSUInteger)index {
    NSIndexPath *indexPath = (NSIndexPath *)plot.identifier;
    
    UIColor *color = [self.dataSource stackedBarChartView:self colorForRowAtIndexPath:indexPath];
    return [CPTFill fillWithColor:[CPTColor colorWithCGColor:[color CGColor]]];
}

#pragma mark - Properties

- (void)setDataSource:(id<YAStackedBarChartViewDataSource>)dataSource {
    if (![_dataSource isEqual:dataSource]) {
        _dataSource = dataSource;
        
        [self reloadData];
    }
}

- (void)setSectionWidth:(CGFloat)sectionWidth {
    if (!(_sectionWidth == sectionWidth)) {
        _sectionWidth = sectionWidth;
        
        [self reloadData];
    }
}

- (void)setDistanceBetweenBars:(CGFloat)distanceBetweenBars {
    if (!(_distanceBetweenBars == distanceBetweenBars)) {
        _distanceBetweenBars = distanceBetweenBars;
        
        [self reloadData];
    }
}


- (void)setOffsetFromLeft:(CGFloat)offsetFromLeft {
    if (!(_offsetFromLeft == offsetFromLeft)) {
        _offsetFromLeft = offsetFromLeft;
        
        [self reloadData];
    }
}

- (void)setOffsetFromRight:(CGFloat)offsetFromRight {
    if (!(_offsetFromRight == offsetFromRight)) {
        _offsetFromRight = offsetFromRight;
        
        [self reloadData];
    }
}

@end
