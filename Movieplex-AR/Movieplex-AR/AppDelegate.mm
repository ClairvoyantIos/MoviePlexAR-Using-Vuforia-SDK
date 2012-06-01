//
//  AppDelegate.m
//  Movieplex-AR
//
//  Created by Girish Hari on 25/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"


#import "ARParentViewController.h"
#import "QCARutils.h"



@implementation AppDelegate

static BOOL firstTime = YES;



// this is the application entry point
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    QCARutils *qUtils = [QCARutils getInstance];
    
    
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    window = [[UIWindow alloc] initWithFrame: screenBounds];
    
    
    // Provide a list of targets we're expecting - the first in the list is the default
    [qUtils addTargetName:@"Movieplex" atPath:@"Movieplex.xml"];
    [qUtils addTargetName:@"Tarmac" atPath:@"Tarmac.xml"];
    
    // Add the EAGLView and the overlay view to the window
    arParentViewController = [[ARParentViewController alloc] init];
    arParentViewController.arViewRect = screenBounds;
    [window insertSubview:arParentViewController.view atIndex:0];
    [window makeKeyAndVisible];
    
    return YES;
}




- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // don't do this straight after startup - the view controller will do it
    if (firstTime == NO)
    {
        // do the same as when the view is shown
        [arParentViewController viewDidAppear:NO];
    }
    
    firstTime = NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // do the same as when the view has dissappeared
    [arParentViewController viewDidDisappear:NO];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // AR-specific actions
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Handle any background procedures not related to animation here.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Handle any foreground procedures not related to animation here.
}

@end
