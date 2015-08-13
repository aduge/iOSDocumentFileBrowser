//
//  AppDelegate.m
//  iOSDocumentFileBrowser
//
//  Created by BinqianDu on 8/13/15.
//  Copyright (c) 2015 Binqian Du. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIImage *image_png1 = [UIImage imageNamed:@"pngSample1"];
    NSData *data_png1 = UIImagePNGRepresentation(image_png1);
    UIImage *image_png = [UIImage imageNamed:@"pngSample"];
    NSData *data_png = UIImagePNGRepresentation(image_png);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath_jpg = [documentsPath stringByAppendingPathComponent:@"pngSample1.png"]; //Add the file name
    NSString *filePath_png = [documentsPath stringByAppendingPathComponent:@"pngSample.png"];
    [data_png1 writeToFile:filePath_jpg atomically:YES]; //Write the file
    [data_png writeToFile:filePath_png atomically:YES];
    
    
    NSString *path_doc = [[NSBundle mainBundle]pathForResource:@"docSample" ofType:@"docx"];
    NSString *path_txt = [[NSBundle mainBundle]pathForResource:@"txtSample" ofType:@"txt"];
    NSData *data_doc = [NSData dataWithContentsOfFile:path_doc];
    NSData *data_txt = [NSData dataWithContentsOfFile:path_txt];
    NSString *filePath_doc = [documentsPath stringByAppendingPathComponent:@"docSample.docx"];
    NSString *filePath_txt = [documentsPath stringByAppendingPathComponent:@"txtSample.txt"];
    [data_doc writeToFile:filePath_doc atomically:YES];
    [data_txt writeToFile:filePath_txt atomically:YES];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
