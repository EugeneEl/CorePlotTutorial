//
//  YAPieChartView.m
//  YACorePlotBlog
//
//  Created by Евгений on 16.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YAPieChartView.h"

static CGFloat const kAreaPaddingTop = 0.0f;
static CGFloat const kAreaPaddingRight = 0.0f;
static CGFloat const kAreaPaddingLeft = 0.0f;
static CGFloat const kAreaPaddingBottom = 0.0f;
static CGFloat const kPieInnerRadius = 51.0f;
static CGFloat const kPieRadius = 100.0f;
static CGFloat const kPieBorderWidth = 1.0f;
static CGFloat const kStartDrawingPoint = M_PI/2.f;
static CGFloat const kMinimalDegreesToDisplay = 3.f;

@interface YAPieChartView () <CPTPieChartDataSource, CPTPieChartDelegate>

@property (nonatomic, strong) CPTXYGraph *graph;
@property (nonatomic, assign) CGFloat degreeAmount;
@property (nonatomic, assign) CGFloat totalAmount;

@end

@implementation YAPieChartView

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
    //Create graph and set it as host view's graph
    self.graph = [[CPTXYGraph alloc] initWithFrame:self.bounds];
    
    CGRect sizeForGraph = self.bounds;
    self.graph.bounds = sizeForGraph;
    [self setHostedGraph:self.graph];
    
    //set border for graph view
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
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.graph.axisSet;
    axisSet.hidden = YES;
    
    CPTAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    CPTXYAxis *x = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    //disable axis for pie chart
    self.graph.axisSet = nil;
    
    _pieInnerCornerRadius = kPieInnerRadius;
    _pieRadius = kPieRadius;
    _borderLineWidth = kPieBorderWidth;
}

#pragma mark - Public

- (void)reloadData {
    
    //calculating total amout of data which we need to display on chart
    self.totalAmount = 0.f;
    NSUInteger numberOfCharts = [_dataSource numberOfSectorsInPieChartView:self];
    for (int i = 0; i < numberOfCharts; i ++) {
        self.totalAmount += [[[_dataSource pieChartView:self sectorAtIndex:i] sectorSize] integerValue];
    }
    
    // Remove previous plots
    [[self.graph allPlots] enumerateObjectsUsingBlock:^(CPTPlot *plot, NSUInteger idx, BOOL *stop) {
        [self.graph removePlot:plot];
    }];
    
        // Add pie chart
        CPTPieChart *piePlot = [[CPTPieChart alloc] init];
        piePlot.dataSource = self;
        piePlot.delegate = self;
        piePlot.pieRadius = _pieRadius;
        piePlot.pieInnerRadius = _pieInnerCornerRadius;
        piePlot.identifier      = @"Pie Chart 1";
        piePlot.startAngle      = kStartDrawingPoint;
        piePlot.sliceDirection  = CPTPieDirectionCounterClockwise;
        CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
        lineStyle.lineColor = [CPTColor whiteColor];
        lineStyle.lineWidth = _borderLineWidth;
        piePlot.borderLineStyle = lineStyle;
    
        [self.graph addPlot:piePlot];

    //Add legend to graph
    CPTLegend *theLegend = [CPTLegend legendWithGraph:self.graph];
    theLegend.numberOfColumns = 2;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = 5.0;
    self.graph.legend = theLegend;
    
    //calculating amount of data for 1 degree and muliplie it by number of minimal degrees to display
    self.degreeAmount= (self.totalAmount / 360.f) * kMinimalDegreesToDisplay;
    
    NSLog(@"totalAmount:%f",self.totalAmount);
    [self.graph reloadData];
}

//implementing methods of Core Plot dataSource and delegate
#pragma mark - CPTPieChartDataSource

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
   return [self.dataSource numberOfSectorsInPieChartView:self];
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    id <YAPieChartProtocol> pieProtocol = [self.dataSource pieChartView:self sectorAtIndex:index];
    if ([[pieProtocol sectorSize] integerValue] < self.degreeAmount) {
        return @(self.degreeAmount);
    }
    return [pieProtocol sectorSize];
}

- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx {
    
    id <YAPieChartProtocol> pieProtocol = [self.dataSource pieChartView:self sectorAtIndex:idx];
    static CPTMutableTextStyle *labelText = nil;
    if (!labelText) {
        labelText= [[CPTMutableTextStyle alloc] init];
        labelText.color = [CPTColor grayColor];
    }
    return [[CPTTextLayer alloc] initWithText:[pieProtocol sectorLegendString] style:labelText];
}

#pragma mark - CPTPieChartDelegate

- (CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    id <YAPieChartProtocol> pieProtocol = [self.dataSource pieChartView:self sectorAtIndex:index];
    return [CPTFill fillWithColor:[CPTColor colorWithCGColor:[[pieProtocol sectorColor] CGColor]]];
}

- (NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx {
    id <YAPieChartProtocol> pieProtocol = [self.dataSource  pieChartView:self sectorAtIndex:idx];
    return [pieProtocol sectorName];
}

#pragma mark - Properties

- (void)setDataSource:(id<YAPieChartViewDataSource>)dataSource {
    if (![_dataSource isEqual:dataSource]) {
        _dataSource = dataSource;
        
        [self reloadData];
    }
}

- (void)setPieInnerCornerRadius:(CGFloat)pieInnerCornerRadius {
    if (!(_pieInnerCornerRadius == pieInnerCornerRadius)) {
        _pieInnerCornerRadius = pieInnerCornerRadius;
        
        [self reloadData];
    }
}

- (void)setPieRadius:(CGFloat)pieRadius {
    if (!(_pieRadius == pieRadius)) {
        _pieRadius = pieRadius;
        
        [self reloadData];
    }
}

- (void)setBorderLineWidth:(CGFloat)borderLineWidth {
    if (!(_borderLineWidth == borderLineWidth)) {
        _borderLineWidth = borderLineWidth;
        
        [self reloadData];
    }
}

@end