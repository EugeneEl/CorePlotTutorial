//
//  YAExercise.h
//  YACorePlotBlog
//
//  Created by Евгений on 15.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface YAExercise : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * colorHexName;
@property (nonatomic, retain) NSSet *sets;
@end

@interface YAExercise (CoreDataGeneratedAccessors)

- (void)addSetsObject:(NSManagedObject *)value;
- (void)removeSetsObject:(NSManagedObject *)value;
- (void)addSets:(NSSet *)values;
- (void)removeSets:(NSSet *)values;

@end
