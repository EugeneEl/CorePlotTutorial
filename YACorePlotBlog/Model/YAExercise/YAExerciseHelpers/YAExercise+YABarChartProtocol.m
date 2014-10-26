//
//  YAExercise+YABarChartProtocol.m
//  CorePlotBlog
//
//  Created by Eugene Goloboyar on 13.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YAExercise+YABarChartProtocol.h"

//model
#import "YASet.h"

//category
#import "UIColor+YAColorWithHexString.h"

@implementation YAExercise (YABarChartProtocol)

- (UIColor *)barColor {
    return [UIColor ya_colorFromHexString:self.colorHexName];
}

- (NSNumber *)barValue {
    return [self.sets valueForKeyPath:@"@sum.repCount"];
}

- (NSString *)barName {
    return self.name;
}

- (NSString *)barLegendString {
    double totalValue = 0;
    for (YASet* set in [YASet MR_findAll]) {
        totalValue += [[set valueForKeyPath:@"repCount"] floatValue];
    }
    double percentage = (100.f * [[self barValue] integerValue]) / totalValue;
    NSString *legendLabelString = [NSString stringWithFormat:@"%@ %ld (%.2f%%)", [self barName], (long)[[self barValue] integerValue], percentage];
    
    return legendLabelString;
}

@end
