//
//  AppDelegate.m
//  Catalog2
//
//  Created by Ashley McCoy on 11/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "AppDelegate.h"
#import "LoadHPMData.h"
#import "RootView.h"


#import "CheckProductsForImages.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize navigationController = _navigationController;

- (void)dealloc
{
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [_navigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    application.statusBarStyle = UIStatusBarStyleBlackOpaque;
    
    ////////////////////////////////////
    /// Is there a Dataset Available ??
    // this call forces a copy of the sqlite db if one has been shipped in the App bundle
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Brand"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    [request release];
    
    ////////////////////////////////////////////
    // otherwize we read the data in from pLists
    if(![result lastObject]){
        LoadHPMData *loader = [[LoadHPMData alloc]init];
        loader.context = self.managedObjectContext; 
        [loader processFiles];
        [loader release];
    }
    
    //////////////////////////////
    // User Defaults
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
       // NSLog(@"FirstLaunch from AppDelegate");
        [[NSUserDefaults standardUserDefaults] 
         registerDefaults:[NSDictionary 
                           dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:YES],@"firstLaunch",
                            [NSNumber numberWithBool:YES],@"ud_Movie",
                            nil]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    
    /////////////////////////////////////////////
    // UI
    
    RootView *viewController = [[[RootView alloc]initWithNibName:nil bundle:nil] autorelease];
    viewController.context = self.managedObjectContext;
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    // reset view controllers if the movie is set play evertime
    //NSLog(@"Resigning Active");
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    if([self.navigationController.viewControllers count] == 1){
       // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ud_Movie"];
    }
    //[[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
    // if the app has gone to back with the main interface as the ending point play the movie.
    if([self.navigationController.viewControllers count] == 1){
        [[self.navigationController.viewControllers objectAtIndex:0] playMovie];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Managed Object Context Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            UIAlertView *dbError = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Internal Data storage Error.\n Please end this application with the home button\nIf you are seeing this error again please reinstall the application." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [dbError show];
            [dbError release];
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Catalog2" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    //NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Catalog2.sqlite"];
    
    ////////////////////////////////////////////////////////
    // copy the shipped sqlite db to the documents directory
    //
   // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    //NSString *documentsDirectory = [paths objectAtIndex:0];
   // NSString *storePath = [documentsDirectory stringByAppendingPathComponent: @"Catalog2.sqlite"];
    NSString *storePath = [[[self applicationDocumentsDirectory] path] stringByAppendingPathComponent:@"Catalog2.sqlite"];
    NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    
    // Put down default db if it doesn't already exist
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:storePath]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] 
                                      pathForResource:@"Catalog2" ofType:@"sqlite"];
       // NSLog(@"\n\n---\nStore path : %@",storePath);
        if (defaultStorePath) {
            NSError *copyError = nil;
            if(![fileManager copyItemAtPath:defaultStorePath toPath:storePath error:&copyError]){
                NSLog(@"\n*****\nERROR Copying\n\n\n %@",[copyError localizedDescription]);
            }else{
                //NSLog(@"\n\n+++\nCOPIED sqllite db");
            }
            
        }
    }
    //
    ////////////////////////////////////////////////////
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Persistent Store Coordinator - Unresolved error %@, %@", error, [error userInfo]);
        //abort();
        
        UIAlertView *dbError = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Internal Data storage Error.\n Please end this application with the home button\nIf you are seeing this error again please reinstall the application." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [dbError show];
        [dbError release];
        
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
