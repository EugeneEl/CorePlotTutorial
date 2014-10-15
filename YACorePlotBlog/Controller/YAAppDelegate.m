//
//  YAAppDelegate.m
//  YACorePlotBlog
//
//  Created by Евгений on 15.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YAAppDelegate.h"

@implementation YAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupCoreDataStack];
    return YES;
}
							
- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}

@end
