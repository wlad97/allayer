//
//  AppDelegate.m
//  Allayer
//
//  Created by Vadim Molchanov on 2/5/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import "AppDelegate.h"
#import "ServerManager.h"
#import "User.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:@"launched_prior"]) {
        [userDefaults setBool:YES forKey:@"launched_prior"];
        [userDefaults setObject:@"Scorpions" forKey:@"default_search"];
        [userDefaults setBool:YES forKey:@"english_only"];
        [userDefaults setInteger:0 forKey:@"popular_genre"];
        [userDefaults synchronize];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
