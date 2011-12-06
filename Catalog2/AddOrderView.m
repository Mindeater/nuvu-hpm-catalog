//
//  AddOrderView.m
//  Catalog2
//
//  Created by Ashley McCoy on 29/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "AddOrderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AddOrderView

@synthesize context;
@synthesize suppliedName;

-(void)dealloc
{
    [context release];
    //[self.suppliedName release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


-(NSArray *)getActiveOrders
{
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *existingEntity = [NSEntityDescription entityForName:@"Order"
                                                      inManagedObjectContext:self.context];
    // Mechanism uses id ad the Unique identifier - yeah :(
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)",
                              @"active",
                              [NSNumber numberWithBool:YES]];
    [request setPredicate:predicate];
    
    [request setEntity:existingEntity];
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    [request release];
    return result;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor=[[UIColor clearColor]CGColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    /// resignFirstResponder 
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%s", __FUNCTION__);
    [textField resignFirstResponder];
    return NO;
}

-(void)confirm:(id)sender
{
    NSLog(@" - -  Supplied Text %@",self.suppliedName.text);
    
    if(!self.suppliedName.text){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HPM Catalog" message: @"Please Enter a Name \nFor your new Order" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        [alert release]; 
        
        //self.suppliedName.layer.cornerRadius=8.0f;
        //self.suppliedName.layer.masksToBounds=YES;
        self.suppliedName.layer.borderColor=[[UIColor redColor]CGColor];
        self.suppliedName.layer.borderWidth= 1.0f;
        
        return;
    }
    
    [self.suppliedName resignFirstResponder];
    
    // get any that are active
    
    
    
     NSError *error;
     NSManagedObject *newEntity = [NSEntityDescription 
                                   insertNewObjectForEntityForName:@"Order"
                                   inManagedObjectContext:self.context];
     
    
    [newEntity setValue:self.suppliedName.text forKey:@"name"];
    [newEntity setValue:
    [NSString stringWithFormat:@"%d", NSTimeIntervalSince1970]
                 forKey:@"uniqueId"];
    [newEntity setValue:[NSNumber numberWithBool:YES] forKey:@"active"];
    
    [self.context insertObject:newEntity];
    [self.context save:&error];
    
    [self dismissModalViewControllerAnimated:YES];

}
-(void)cancel:(id)sender
{
    [self.suppliedName resignFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ///////////////////
    // Information
    UILabel *info = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, 600, 40)];
    info.backgroundColor = [UIColor whiteColor];
    info.text = @"Choose a name for your new Order:";
    
    [self.view addSubview:info];
    [info release];
    /////////////////
    // text input
    suppliedName = [[UITextField alloc]initWithFrame:CGRectMake(20, 60, 300, 20)];
    suppliedName.placeholder = @"Your Order Name";
    suppliedName.clearsOnBeginEditing = YES;
    suppliedName.delegate =self;
    suppliedName.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:suppliedName];
    //[suppliedName release];
    /////////////////
    // confirm
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [confirm addTarget:self 
               action:@selector(confirm:)
     forControlEvents:UIControlEventTouchDown];
    [confirm setTitle:@"Confirm" forState:UIControlStateNormal];
    confirm.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:confirm];
    /////////////////
    // cancel
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancel addTarget:self 
               action:@selector(cancel:)
     forControlEvents:UIControlEventTouchDown];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    cancel.frame = CGRectMake(80.0, 270.0, 160.0, 40.0);
    [self.view addSubview:cancel];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
