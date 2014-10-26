//
//  YASet.h
//  YACorePlotBlog
//
//  Created by Eugene Goloboyar on 15.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YAExercise;

@interface YASet : NSManagedObject

@property (nonatomic, retain) NSDate * doneAt;
@property (nonatomic, retain) NSNumber * repCount;
@property (nonatomic, retain) YAExercise *exercise;

@end
