//
//  YAExercise+YABarChartProtocol.m
//  CorePlotBlog
//
//  Created by Евгений on 13.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YAExercise+YABarChartProtocol.h"

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


@end
