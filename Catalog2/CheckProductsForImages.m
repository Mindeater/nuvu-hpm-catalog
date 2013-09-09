//
//  CheckProductsForImages.m
//  Catalog2
//
//  Created by Ashley McCoy on 24/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "CheckProductsForImages.h"

@implementation CheckProductsForImages

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context = _context;

@synthesize outputLog;

@synthesize mechCount,productCount,facePlateCount,missingMech,missingFaceplates;

-(void)dealloc
{
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
    self.context = nil;
    [super dealloc];
}

#pragma mark - Core Data

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Product" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"name" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:_context sectionNameKeyPath:nil 
                                                   cacheName:@"allProducts"];
    
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    [sort release];
    [fetchRequest release];
    [theFetchedResultsController release];
    return _fetchedResultsController;    
    
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)checkMechanismImages
{
    for(NSManagedObject *product in self.fetchedResultsController.fetchedObjects){
       // NSLog(@"Mech %@",[product valueForKey:@"name"]);
        NSString *currentBrand = [[product valueForKey:@"brand"]
                                             valueForKey:@"name"];
        NSString *currentCategory = [[product valueForKey:@"category"]
                                                valueForKey:@"name"];
        NSString *currentOrientation = [self getOrientationPrefix: [product valueForKey:@"orientation"]];
        
        // Get all the mechanisms assosiated with the product
        NSFetchRequest*request = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Mechanism"
                                                  inManagedObjectContext:_context];
        [request setEntity:entity];
        //NSLog(@"Product check +++");
        
        NSPredicate *predicate= [NSPredicate predicateWithFormat:
                                 @"(%K == %@)",
                                 @"product.name",
                                 [product valueForKey:@"name"]];
        
        [request setPredicate:predicate];    
        NSError *error = nil;
        
        NSArray *result = [_context executeFetchRequest:request error:&error];
        if (result == nil)
        {
            // Deal with error...
            NSLog(@"Error Returned from the fetchRequest ");
        }
        
        [self getMechanismImagePaths:result forBrand:currentBrand andCategory:currentCategory withOrientation:currentOrientation];
        
        self.productCount++;
    }
}
-(void)getMechanismImagePaths:(NSArray *)mechanisms
                     forBrand:(NSString *)brand
                  andCategory:(NSString *)category
              withOrientation:(NSString *)orientation

{
    for(NSManagedObject *mech in mechanisms){
        NSString *img;
        
        if([[mech valueForKey:@"count"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            // load the image based on the id screen the Arteor 770 fields
            if([[mech valueForKey:@"name"] isEqualToString:@"Mech 2 Part #"]){
                img = [[mech valueForKey:@"id"] 
                       stringByReplacingOccurrencesOfString:@"AR" withString:@""];
            }else{
                img = [mech valueForKey:@"id"];
            }
            
        }else{
            // mechanism with more than one part
            img = [NSString stringWithFormat:@"%@-x-%@",
                   [mech valueForKey:@"count"],
                   [[mech valueForKey:@"id"]
                    stringByReplacingOccurrencesOfString:@"AR" withString:@""]];
        }
        
        // Is is a frame ?
        NSString *dir;
        if([[mech valueForKey:@"name"] isEqualToString:@"Frame"]){
            dir = @"Frames";
            orientation = @"";
        }else{
            dir = [NSString stringWithFormat:@"%@/Mechanism",
                   [brand stringByReplacingOccurrencesOfString:@" " withString:@""]];
        }
        
        //NSLog(@" Directory %@",dir);
        NSString *imgCleaned = [NSString stringWithFormat:@"%@%@",
                                orientation,
                                [img stringByReplacingOccurrencesOfString:@"/" withString:@"-"]];
        
        //NSLog(@"  - File NAme %@",imgCleaned);
        // Grab the image off disk and load it up
        NSString *imageName = [[NSBundle mainBundle] 
                               pathForResource:imgCleaned
                               ofType:@"png" 
                               inDirectory:dir];
        
        
        if(!imageName){
            [self.outputLog appendString:[NSString stringWithFormat:@"Mechanism,%@,%@,%@,%@,%@\n",
                                          brand,
                                          category,
                                          img,
                                          dir,
                                          imgCleaned] ];
            //NSLog(@" FuLL image NAme:  %@",imageName);
            self.missingMech++;
        }else{
            //NSLog(@"HAppy CAmper");
        
        }
        self.mechCount++;
    }
    
}

-(void)logPathCheck:(NSDictionary *)pathMap
{
    /// loop through and chack for Nil ??
}

-(void)checkFaceplateImages
{
    for(NSManagedObject *product in self.fetchedResultsController.fetchedObjects){
        NSString *currentBrand = [[product valueForKey:@"brand"]
                                  valueForKey:@"name"];
        NSString *currentCategory = [[product valueForKey:@"category"]
                                     valueForKey:@"name"];
        NSString *currentOrientation = [self getOrientationPrefix: [product valueForKey:@"orientation"]];
        
        // Get all the mechanisms assosiated with the product
        NSFetchRequest*request = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Faceplate"
                                                  inManagedObjectContext:_context];
        [request setEntity:entity];
        
        NSPredicate *predicate= [NSPredicate predicateWithFormat:
                                 @"(%K == %@)",
                                 @"product.name",
                                 [product valueForKey:@"name"]];
        
        [request setPredicate:predicate];    
        NSError *error = nil;
        
        NSArray *result = [_context executeFetchRequest:request error:&error];
        if (result == nil)
        {
            // Deal with error...
            NSLog(@"Error Returned from the fetchRequest ");
            UIAlertView *dbError = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Internal Data storage Error.\n Please end this application with the home button\nIf you are seeing this error again please reinstall the application." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [dbError show];
            [dbError release];
        }
        
        [self getFacePlateImagePaths:result forBrand:currentBrand andCategory:currentCategory withOrientation:currentOrientation];
        
    }
}

-(void)getFacePlateImagePaths:(NSArray *)faceplates
                     forBrand:(NSString *)brand
                  andCategory:(NSString *)category
              withOrientation:(NSString *)orientation
{
    for(NSManagedObject *faceplate in faceplates){
        NSString *img = [faceplate valueForKey:@"id"];
        
        NSString *dir = [NSString stringWithFormat:@"%@/Faceplate",
                         [brand stringByReplacingOccurrencesOfString:@" " withString:@""]];
        
        NSString *imgCleaned = [NSString stringWithFormat:@"%@%@",
                                orientation,
                                [img stringByReplacingOccurrencesOfString:@"/" withString:@"-"]];
        
        //NSLog(@"  - File NAme %@",imgCleaned);
        // Grab the image off disk and load it up
        NSString *imageName = [[NSBundle mainBundle] 
                               pathForResource:imgCleaned
                               ofType:@"png" 
                               inDirectory:dir];
        if(!imageName){
            [self.outputLog appendString:[NSString stringWithFormat:@"Faceplate,%@,%@,%@,%@,%@\n",
                                         brand,
                                         category,
                                         img,
                                         dir,
                                         imgCleaned] ];
            //NSLog(@" - - - Path\n %@\n",imageName);
            self.missingFaceplates++;
        }
        self.facePlateCount++;
        
    }
}

-(NSString *)getOrientationPrefix:(NSString *)value
{
    NSString *orientationPrefix;
    // retain the passed value
    if([value isEqualToString:@"Horizontal"]){
        orientationPrefix = @"h-";
    }else if([value isEqualToString:@"Vertical"]){
        orientationPrefix = @"v-";
    }else{
        orientationPrefix = @"";
    }
    return orientationPrefix;
}

-(void)runCheck
{
    NSError *error;
    NSLog(@"Product check +++");
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    self.mechCount = 0;
    self.facePlateCount = 0;
    self.productCount = 0;
    self.missingMech = 0;
    self.missingFaceplates = 0;
    
    self.outputLog = [NSMutableString stringWithFormat: @"\n"];
    [self checkMechanismImages];
    [self checkFaceplateImages];
    
    NSLog(@"\n\n%@",self.outputLog);
    
    NSLog(@"Report\n------\nProducts: %d\nMechansims: %d/%d\nFaceplates: %d/%d",
          self.productCount,
          self.missingMech,
          self.mechCount,
          self.missingFaceplates,
          self.facePlateCount);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
