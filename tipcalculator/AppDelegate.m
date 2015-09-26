//
//  AppDelegate.m
//  tipcalculator
//
//  Created by Florent Bonomo on 9/20/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic) NSDate *enterBackgroundTime;

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.tipModel = [[Tip alloc] init];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    self.enterBackgroundTime = [NSDate date];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSInteger elapsed = (NSInteger)[self.enterBackgroundTime timeIntervalSinceNow];

    // Clear model after 10 minutes of inactivity
    if (elapsed < -600) {
        [self.tipModel clear];
    }
}

@end
