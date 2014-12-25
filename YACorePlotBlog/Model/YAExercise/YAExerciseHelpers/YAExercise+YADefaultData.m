//
//  YAExercise+YADefaultData.m
//  CorePlotBlog
//
//  Created by Eugene Goloboyar on 14.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YAExercise+YADefaultData.h"

@implementation YAExercise (YADefaultData)

+ (void)ya_defaultData {
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YAExercises" ofType:@"plist"]];
    NSManagedObjectContext *ctx = [NSManagedObjectContext MR_contextForCurrentThread];
   [self MR_importFromArray:array inContext:ctx];
    [ctx MR_saveToPersistentStoreAndWait];
}

@end
