//
//  YABartChartView.m
//  CorePlotBlog
//
//  Created by Евгений on 13.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YABarChartView.h"

static CGFloat const kAreaPaddingTop = 0.0f;
static CGFloat const kAreaPaddingRight = 10.0f;
static CGFloat const kAreaPaddingLeft = 20.0f;
static CGFloat const kAreaPaddingBottom = 40.0f;
static CGFloat const kAxisXLabelTextFontSize = 12.0f;
static CGFloat const kAxisXLabelOffset = 0.0f;
static CGFloat const kBarOffset = 5.0f;
static CGFloat const kBarWidth = 5.0f;
static CGFloat const kLineWidth = 1.0f;
static CGFloat const kMajorTickLength = 5.0f;
static CGFloat const kMinorTickLength = 5.0f;
static CGFloat const kDefaultTickInterval = 1.0f;
static CGFloat const kBorderLineStyleWidth = .5f;
static CGFloat const kNumberOfTicksAtXAxes = 12.f;
static CGFloat const kMultiplierForMimimalBarValue = 0.015f;
static NSUInteger const kMultiplierToAdjustAxisYSize = 10;


@interface YABarChartView () <CPTBarPlotDataSource, CPTBarPlotDelegate>

@property (nonatomic, strong) CPTXYGraph *graph;
@property (nonatomic, assign) CGFloat defaultMinimalBarValue;

@end

@implementation YABarChartView

#pragma mark - Initialization

- (void)awakeFromNib {
    [self commonInit];
    [self reloadData];
}

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
    //Create graph and set it as host view's graph
    self.graph = [[CPTXYGraph alloc] initWithFrame:self.bounds];
    [self setHostedGraph:self.graph];
    
    //remove default core plot border around graph
    [self.graph setValue:@(0.f) forKey:@"paddingLeft"];
    [self.graph setValue:@(0.f) forKey:@"paddingTop"];
    [self.graph setValue:@(0.f) forKey:@"paddingRight"];
    [self.graph setValue:@(0.f) forKey:@"paddingBottom"];
    
    //set graph padding and theme
    self.graph.plotAreaFrame.paddingTop = kAreaPaddingTop;
    self.graph.plotAreaFrame.paddingRight = kAreaPaddingRight;
    self.graph.plotAreaFrame.paddingBottom = kAreaPaddingBottom;
    self.graph.plotAreaFrame.paddingLeft = kAreaPaddingLeft;
    self.graph.plotAreaFrame.plotArea.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    
    //setup axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    
    //setup style for label for X axis
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Arial";
    textStyle.fontSize = kAxisXLabelTextFontSize;
    textStyle.color = [CPTColor colorWithCGColor:[UIColor blueColor].CGColor];
    
    axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    axisSet.xAxis.labelTextStyle = textStyle;
    axisSet.xAxis.labelOffset = kAxisXLabelOffset;
    
    //set axes' line styles and interval ticks
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor colorWithCGColor:[UIColor grayColor].CGColor];
    lineStyle.lineWidth = kLineWidth;
    
    //setup format for x labels axes
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setGeneratesDecimalNumbers:TRUE];
    
    axisSet.xAxis.labelFormatter = formatter;
    
    // Y Axis
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.axisLineStyle = lineStyle;
    
    // X Major Tick
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(kDefaultTickInterval);
    axisSet.xAxis.majorTickLength = kMajorTickLength;
    
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLength = kMinorTickLength;
    
    axisSet.xAxis.majorGridLineStyle = lineStyle;
    
    // Create bar plot and add it to the graph
    CPTBarPlot *plot = [[CPTBarPlot alloc] init];
    plot.dataSource = self;
    plot.delegate = self;
    [plot setBarsAreHorizontal:YES];
    plot.barWidth = [[NSDecimalNumber numberWithFloat:kBarWidth] decimalValue];
    plot.barOffset = [[NSDecimalNumber numberWithFloat:kBarOffset] decimalValue];
    [plot setBarsAreHorizontal:YES];
    
    // Remove bar outlines
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor whiteColor];
    borderLineStyle.lineWidth = kBorderLineStyleWidth;
    plot.lineStyle = borderLineStyle;
    
    //makes all Plot reload their data
    [self.graph addPlot:plot];
}


#pragma mark - Private

- (void)reloadData {
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    
    NSInteger numberOfPlots = [self.dataSource numberOfChartsInBarChartView:self];
    
    //calculated maxWidth  plot
    CGFloat maxWidth = 0.f;
    for (int i = 0; i < numberOfPlots; i++) {
        id <YABarChartProtocol> barProtocol = [self.dataSource barChartView:self plotAtIndex:i];
        maxWidth = fmaxf(maxWidth, [[barProtocol barValue] floatValue]);
    }
    
    //recalculated plotSpace for X axe with maxWidth
    //recalculated plotSpace for Y axe with number of plots multipled by some constant
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(0.f)
                                                    length:CPTDecimalFromCGFloat(maxWidth+1.f)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(0.f)
                                                    length:CPTDecimalFromInteger((numberOfPlots)*kMultiplierToAdjustAxisYSize)];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    
    //recalculated default minimalBarValue for to make all plots visible even if they depict small amouts of data
    self.defaultMinimalBarValue = ((maxWidth) * kMultiplierForMimimalBarValue);

    //recalculated interval for axis
    if (maxWidth > 20.0f) {
        float intervalLength = maxWidth / kNumberOfTicksAtXAxes;
        axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(ceilf(intervalLength));
        
    } else if (maxWidth == 0) {
        axisSet.xAxis.majorGridLineStyle = nil;
    }
    
    //makes all Plot reload their data
    [self.graph reloadData];
}
//
#pragma mark - CPTPlotDataSource

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [self.dataSource numberOfChartsInBarChartView:self];
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    id <YABarChartProtocol> barProtocol = [self.dataSource barChartView:self plotAtIndex:index];
    
    //for Y coordinate we return index of plot multupled by our constant
    if (fieldEnum == CPTBarPlotFieldBarLocation) {
        return @(index*kMultiplierToAdjustAxisYSize);
        
    //for X coordninate we return value (width) of Plot or calculated default minimalValue
    } else if (fieldEnum == CPTBarPlotFieldBarTip) {
        if ([[barProtocol barValue] doubleValue] < self.defaultMinimalBarValue) {
            return @(self.defaultMinimalBarValue);
        }
        return [barProtocol barValue];
    } else {
        NSAssert(NO, @"Undefined fieldEnum: %ld", (unsigned long)fieldEnum);
        return nil;
    }
}

#pragma mark - CPTBarPlotDataSource

- (CPTFill *)barFillForBarPlot:(CPTBarPlot *)plot recordIndex:(NSUInteger)index {
    //any object which implemented methods of <YABarChartProtocol> can return color for plot
    id <YABarChartProtocol> barProtocol = [self.dataSource barChartView:self plotAtIndex:index];
    
    return [CPTFill fillWithColor:[CPTColor colorWithCGColor:[[barProtocol barColor] CGColor]]];
}

#pragma mark - Properties

- (void)setDataSource:(id<YABarChartViewDataSource>)dataSource {
    if (![_dataSource isEqual:dataSource]) {
        _dataSource = dataSource;
        
        //reload data after setting dataSource
        [self reloadData];
    }
}

@end

