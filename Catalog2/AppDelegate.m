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


//#import "CheckProductsForImages.h"
//#import "FlurryAnalytics.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize navigationController = _navigationController;
@synthesize sqlite_db_name = _sqlite_db_name;

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

    //[FlurryAnalytics startSession:@"8LBWW5P4BZN62SC7GQRA"];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    application.statusBarStyle = UIStatusBarStyleBlackOpaque;
    
    // Which version are we ??
#ifdef NZVERSION
    _sqlite_db_name = @"Catalog2-NZ";
#else
    _sqlite_db_name = @"Catalog2";
#endif
    
    ////////////////////////////////////
    /// Is there a Dataset Available ??
    // this call forces a copy of the sqlite db if one has been shipped in the App bundle
   
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Brand"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request
                                                               error:&error];
    [request release];
    
    ////////////////////////////////////////////
    // DEVELOPMENT CODE ONLY
    // Read the data in from pLists and create the sqlite DB
    // !! This should not happen on a live device
    
    if(![result lastObject]){
        LoadHPMData *loader = [[LoadHPMData alloc]init];
        loader.context = self.managedObjectContext; 
        [loader processFiles];
        [loader release];
    }
    
    //////////////////////////////////////////////////////
    // If there has never been an update make sure it runs
    

    if( ! [[NSUserDefaults standardUserDefaults] boolForKey:@"UpdatePrices"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"UpdatePrices"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //////////////////////////////////////////////////////
    // If there is no version number set it now
    // the app has been running and this is the first time it's been updated
    
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"version"]){
//        [[NSUserDefaults standardUserDefaults]
//         registerDefaults:[NSDictionary
//                           dictionaryWithObjectsAndKeys:
//                           [NSNumber numberWithFloat:1.2f],@"version",
//                           nil]];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
    
    ////////////////////////////////////////////////////////
    // User Defaults if they have never been set
    // this means the standard sqlite db will be used
    
    // firstLaunch will be YES after the App runs once
    
    if( ! [[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
//        [[NSUserDefaults standardUserDefaults]
//         registerDefaults:[NSDictionary 
//                           dictionaryWithObjectsAndKeys:
//                            [NSNumber numberWithBool:NO],   @"firstLaunch",
//                            [NSNumber numberWithBool:YES],  @"playMovie",
//                            [NSNumber numberWithBool:YES],  @"ud_Movie",
//                            [NSNumber numberWithBool:NO],   @"UpdatePrices",
//                            [NSNumber numberWithFloat:1.4f],@"version",
//                            nil]];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"playMovie"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ud_Movie"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"UpdatePrices"];
        [[NSUserDefaults standardUserDefaults] setFloat:1.4f forKey:@"version"];


        if([[NSUserDefaults standardUserDefaults] synchronize])
        {
            NSLog(@"SYNCHED NSUserDefaults");
        }
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
    
    //[FlurryAnalytics logAllPageViews:self.navigationController];
    
    return YES;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
//    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
//    [navigationController shouldAutorotate];
//    [navigationController preferredInterfaceOrientationForPresentation];
//    return UIInterfaceOrientationMaskAll;
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
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
    
    // 1. Get the default DB path
    NSString *storePath = [[[self applicationDocumentsDirectory] path]
                           stringByAppendingPathComponent:@"Catalog2.sqlite"];
    NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    
    // 2. See if it is already there
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:storePath])
    {
        // 3. Get the shipped one
        NSString *shippedStorePath = [[NSBundle mainBundle]
                                      pathForResource:_sqlite_db_name ofType:@"sqlite"];
        
        // 4. Replace it with our Shipped DB if there is one
        if (shippedStorePath) {
            NSError *copyError = nil;
//            if(![fileManager copyItemAtPath:shippedStorePath toPath:storePath error:&copyError])
            if(![fileManager moveItemAtPath:shippedStorePath toPath:storePath error:&copyError])
            {
                NSLog(@"\n*****\nERROR Copying\n\n\n %@",[copyError localizedDescription]);
            }else{
                NSLog(@"\n\n+++\nCOPIED sqllite db");
            }
            
        }
    }
    //
    ////////////////////////////////////////////////////
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                    configuration:nil
                                                              URL:storeURL
                                                          options:nil
                                                            error:&error])
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
