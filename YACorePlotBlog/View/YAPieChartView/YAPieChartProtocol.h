//
//  YAPieChartProtocol.h
//  YACorePlotBlog
//
//  Created by Евгений on 16.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YAPieChartProtocol <NSObject>

@required

- (UIColor *)pieColor;
- (NSNumber *)pieAmountForSectorSize;

@end
