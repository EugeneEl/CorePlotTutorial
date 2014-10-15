//
//  YAViewController.m
//  YACorePlotBlog
//
//  Created by Евгений on 15.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YAViewController.h"
#import "YAExercise.h"

@interface YAViewController ()

@end

@implementation YAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", [YAExercise MR_findAll]);
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
