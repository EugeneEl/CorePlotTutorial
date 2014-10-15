//
//  YAAppDelegate.m
//  YACorePlotBlog
//
//  Created by Евгений on 15.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YAAppDelegate.h"

//category
#import "YAExercise+YADefaultData.h"

@implementation YAAppDelegate

static NSString *const kYAFirstRunKey = @"kYAFirstRunKey";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupCoreDataStack];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kYAFirstRunKey] == nil) {
        [YAExercise ya_defaultData];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kYAFirstRunKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}

@end
