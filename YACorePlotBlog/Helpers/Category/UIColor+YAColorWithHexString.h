//
//  UIColor+YAColorWithHexString.h
//  CorePlotBlog
//
//  Created by Eugene Goloboyar on 13.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YAColorWithHexString)

+ (UIColor *)ya_colorFromHexString:(NSString *)hexString;

@end
