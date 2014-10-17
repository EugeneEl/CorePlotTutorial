//
//  YAExercise+YAPieChartProtocol.m
//  YACorePlotBlog
//
//  Created by Евгений on 16.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YAExercise+YAPieChartProtocol.h"

//category
#import "UIColor+YAColorWithHexString.h"

@implementation YAExercise (YAPieChartProtocol)

- (UIColor *)pieColor {
    return [UIColor ya_colorFromHexString:self.colorHexName];
}

- (NSNumber *)pieAmountForSectorSize {
    return [self.sets valueForKeyPath:@"@sum.repCount"];
}

- (NSString *)pieName {
    return self.name;
}

@end
