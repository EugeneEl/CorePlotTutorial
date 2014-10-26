//
//  YAExercise+YAPieChartProtocol.m
//  YACorePlotBlog
//
//  Created by Eugene Goloboyar on 16.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YAExercise+YAPieChartProtocol.h"

//model
#include "YASet.h"

//category
#import "UIColor+YAColorWithHexString.h"

@implementation YAExercise (YAPieChartProtocol)

- (UIColor *)sectorColor {
    return [UIColor ya_colorFromHexString:self.colorHexName];
}

- (NSNumber *)sectorSize {
    return [self.sets valueForKeyPath:@"@sum.repCount"];
}

- (NSString *)sectorName {
    return self.name;
}

- (NSString *)sectorLegendString {
    double totalValue = 0;
    for (YASet* set in [YASet MR_findAll]) {
        totalValue += [[set valueForKeyPath:@"repCount"] floatValue];
    }
    double percentage = (100.f * [[self sectorSize] integerValue]) / totalValue;
    NSString *legendLabelString = [NSString stringWithFormat:@"%@ %ld (%.2f%%)", [self sectorName], (long)[[self sectorSize] integerValue], percentage];
    return legendLabelString;
}

@end
