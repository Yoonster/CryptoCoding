//
//  TodoListAppDelegate.m
//  TodoList
//
//  Created by Nick Lockwood on 08/04/2010.
//  Copyright Charcoal Design 2010. All rights reserved.
//

#import "TodoListAppDelegate.h"
#import "TodoListViewController.h"

@implementation TodoListAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc
{
    [viewController release];
    [window release];
    [super dealloc];
}


@end
