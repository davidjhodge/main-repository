//
//  AppDelegate.m
//  Social Network
//
//  Created by David Hodge on 10/18/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "GTScrollNavigationBar.h"
#import "PostTVC.h"
#import <CoreData/CoreData.h>
#import "AmazonFetcher.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AppDelegate ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x00B8F5)];
    return YES;
}

#pragma mark - Core Data
/*
-(NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc]init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Data Model" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationStoresDirectory] URLByAppendingPathComponent:@"Test.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    //Create dictionary of options to tell Core Data how to migrate the persistent store to match the updated data model
 
     //NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @(YES),
     //NSInferMappingModelAutomaticallyOption : @(YES)};
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        //Move user's persistent store data to a safe location
        NSFileManager *fm = [NSFileManager defaultManager];
        //Move Incompatible Store
        if ([fm fileExistsAtPath:[storeURL path]]) {
            NSURL *corruptURL = [[self applicationIncompatibleStoresDirectory] URLByAppendingPathComponent:[self nameForIncompatibleStore]];
            
            //Move corrupt store
            NSError *errorMoveStore = nil;
            [fm moveItemAtURL:storeURL toURL:corruptURL error:&error];
            
            if (errorMoveStore) {
                NSLog(@"Unable to move corrupt store");
            }
        }
        
        NSError *errorAddingStore = nil;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&errorAddingStore]) {
            
            NSLog(@"Unable to create persistent store after recovery. %@,%@", errorAddingStore,errorAddingStore.localizedDescription);
        }
        
        //Show Alert View to notify user of the incompatiblity
        NSString *title = @"Warning";
        NSString *applicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        NSString *message = [NSString stringWithFormat:@"A serious error occurred while %@ tried to read your data. Please contact support for help.",applicationName];
        
        [[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
    return _persistentStoreCoordinator;
}

//Location of the Persistent Store
-(NSURL *)applicationStoresDirectory
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *applicationSupportDirectory = [[fm URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *URL = [applicationSupportDirectory URLByAppendingPathComponent:@"Test"];
    
    if (![fm fileExistsAtPath:[URL path]]) {
        //file does not exist
        NSError *error = nil;
        [fm createDirectoryAtURL:URL withIntermediateDirectories:YES attributes:nil error:&error];
        
        //error checking
        if (error) {
            NSLog(@"Unable to create directory for data stores.");
            
            return nil;
        }
        
    }
    
    return URL;
}

//Location of the incompatible store if corruption occurs
-(NSURL *)applicationIncompatibleStoresDirectory
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *URL = [[self applicationStoresDirectory] URLByAppendingPathComponent:@"Incompatible"];
    
    if (![fm fileExistsAtPath:[URL path]]) {
        //file does not exist
        NSError *error = nil;
        [fm createDirectoryAtURL:URL withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error) {
            NSLog(@"Unable to create directory for corrupt data stores.");
            
            return nil;
        }
    }
    return URL;
}

//Inside the Incompatible Directory, name each corrupted store by the date
-(NSString *)nameForIncompatibleStore
{
    //Initialize Date Formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    //Configure Date Formatter
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    
    return [NSString stringWithFormat:@"%@.sqlite", [dateFormatter stringFromDate:[NSDate date]]];
}
*/
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
    
    //Delete Document on Save
    //[self deleteUIManagedDocument];
}

-(void)deleteUIManagedDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"SNDemoDoc"];
    
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    [document closeWithCompletionHandler:^(BOOL success){
        if([[NSFileManager defaultManager] fileExistsAtPath:[document.fileURL path]]){
            [[NSFileManager defaultManager] removeItemAtURL:document.fileURL error:nil];
        }}];
}

@end
