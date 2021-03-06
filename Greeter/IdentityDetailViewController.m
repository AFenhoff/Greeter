//
//  IdentityDetailViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 3/10/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "IdentityDetailViewController.h"
#import "GreeterHomeViewController.h"
#import "DocumentationMenuViewController.h"
#import "VehicleMenuViewController.h"
#import "SelectMaterialTableViewController.h"
#import "Common.h"
#import "NameViewController.h"

@interface IdentityDetailViewController ()

@end

@implementation IdentityDetailViewController

@synthesize tableView, finishButton, materialButton, documentsButton, vehicleButton, toolbar;
@synthesize vehicleOrIDRequired, allItemsComplete, syncButton;

bool _vehicleCaptured = NO;
bool _documentsCaptured = NO;
bool _materialCaptured = NO;
bool _nameCaptured = YES;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    vehicleOrIDRequired = YES;
    
    //Removes documents button until we are ready to do documents
    NSMutableArray *toolbarButtons = [self.toolbar.items mutableCopy];
    [toolbarButtons removeObject:self.documentsButton];
    toolbar.items = toolbarButtons;
    _documentsCaptured = YES;

}

- (void) viewDidAppear:(BOOL)animated
{
    [self allItemsAreComplete];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    if(!sharedObjects.selectedSupplier)
    {
        Supplier *supp = (Supplier *)[NSEntityDescription insertNewObjectForEntityForName:@"Supplier" inManagedObjectContext:sharedObjects.managedObjectContext];
        
        supp.supplierName   = @"Peddler (No Acct)";
        supp.supplierNo     = @"******";
        supp.supplierType   = @"P";
        supp.idRequired     = [NSNumber numberWithInt:1];
        supp.fingerPrint    = 0;
        supp.rowid          = 0;
        supp.idNumber       = @"";
        
        NSError *error = nil;
        if (![sharedObjects.managedObjectContext save:&error]) {
            // Handle the error.
        }
        sharedObjects.selectedSupplier = supp;
        _nameCaptured = NO;
    }else{ _nameCaptured = YES; }

    NSString *fullName = [NSString stringWithFormat:@"%@ %@", sharedObjects.selectedSupplier.firstName, sharedObjects.selectedSupplier.lastName];
    if([fullName isEqualToString:@"(null) (null)"]){ fullName = @"N/A (Press Here to Change)"; }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"NAME";
            cell.detailTextLabel.text = fullName;
            break;
        case 1:
            cell.textLabel.text = @"SUPPLIER NAME";
            cell.detailTextLabel.text = sharedObjects.selectedSupplier.supplierName ? sharedObjects.selectedSupplier.supplierName : @"N/A";

            break;
        case 2:
            cell.textLabel.text = @"ID NUMBER";
            cell.detailTextLabel.text = sharedObjects.selectedSupplier.idNumber ? sharedObjects.selectedSupplier.idNumber : @"N/A";
            break;
        case 3:
            cell.textLabel.text = @"SUPPLIER TYPE";
            cell.detailTextLabel.text = [sharedObjects.selectedSupplier.supplierType length] == 0 ? @"N/A" : sharedObjects.selectedSupplier.supplierType;//@"PEDDLER (may have suppliers)";
            break;
        case 4:
            cell.textLabel.text = @"VEHICLE / ID REQUIRED : ID Photo On File";
            cell.detailTextLabel.text = [sharedObjects.selectedSupplier.idRequired intValue] == 1 ? @"YES" : @"NO";
            break;
        case 5: //License expiration date and Age, make it red if under 18
            //button to view license photo
            
            break;
            
        default:
            break;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0){ return; }
    [self performSegueWithIdentifier:@"firstAndLastName" sender:self];
    
}

-(void) animateToolbarToColor:(UIColor *)color
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    toolbar.backgroundColor = color;
    [UIView commitAnimations];
}

-(IBAction)finishButtonPressed:(id)sender
{
    
    /***************************************************
     Save all information here
     ***************************************************/
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    sharedObjects.dataManager.delegate = self;
    [sharedObjects.dataManager saveGreeterQueue];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((BaseModalViewController *)segue.destinationViewController).delegate = self;
    /*
    ((BaseModalViewController *)segue.destinationViewController).delegate = self;
    
    switch (((UIBarButtonItem *)sender).tag) {
        case 0: //Vehicle
            
            break;
        case 1: //Documents
            
            break;
        case 2: //Material
            
            break;
            
        default:
            break;
    }
     */
    
}

-(IBAction)vehicleButtonPressed:(id)sender
{
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    sharedObjects.dataManager.delegate = self;
    [sharedObjects.dataManager getSupplierVehiclesBySupplierNo:sharedObjects.selectedSupplier.supplierNo
                                                   andIDNumber:sharedObjects.selectedSupplier.idNumber forDelegate:self];
    
}

-(void)dataDidSync:(id)sender
{
    [self performSegueWithIdentifier:@"vehicles" sender:self];
}

-(void)recordCreatedSuccessfully:(id)sender
{
    //DataManager's delegate method (dataDidSync) needs more info so we can determine which segue to fire
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[GreeterHomeViewController class]]) {
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            break;
        }
    }
    
}

-(void)modalComplete:(id)sender
{
    if ([sender isKindOfClass:[VehicleMenuViewController class]])
    {
        _vehicleCaptured = YES;
    }
    
    if ([sender isKindOfClass:[DocumentationMenuViewController class]])
    {
        _documentsCaptured = YES;
    }
    
    if ([sender isKindOfClass:[SelectMaterialTableViewController class]])
    {
        _materialCaptured = YES;
    }
    
    [self allItemsAreComplete];
    
    if ([sender isKindOfClass:[NameViewController class]])
    {
        _nameCaptured = YES;
        [tableView reloadData];
    }
}

-(void)modalCanceled:(id)sender
{
    
}

-(void)allItemsAreComplete
{
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    syncButton.enabled = _nameCaptured && sharedObjects.selectedVehicle && _documentsCaptured && ((sharedObjects.greeterType == FE && sharedObjects.selectedMaterial) || sharedObjects.greeterType == NF);
    //toolbar.backgroundColor = syncButton.enabled ? [UIColor grayColor] : [UIColor redColor];
    
    /**************************************************************
     TODO:
     Only turn Vehicle button red if vehicle required
     **************************************************************/
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    
    if (!syncButton.enabled)
    {
        //[self animateToolbarToColor:[UIColor redColor]];
        toolbar.backgroundColor = [UIColor redColor];

    }else{
        [syncButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIFont fontWithName:@"Helvetica-Bold" size:26.0], NSFontAttributeName,
                                               [UIColor greenColor], NSForegroundColorAttributeName,
                                               nil]
                                     forState:UIControlStateNormal];
        //[self animateToolbarToColor:[UIColor grayColor]];
        toolbar.backgroundColor = [UIColor grayColor];
    }
    
    if(!sharedObjects.selectedVehicle)
    {
        [vehicleButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"Helvetica-Bold" size:26.0], NSFontAttributeName,
                                        [UIColor greenColor], NSForegroundColorAttributeName,
                                        nil] 
                              forState:UIControlStateNormal];
    }else{
        [vehicleButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIFont fontWithName:@"System" size:17.0], NSFontAttributeName,
                                               [UIColor whiteColor], NSForegroundColorAttributeName,
                                               nil]
                                     forState:UIControlStateNormal];

    }
    [UIView commitAnimations];

    
}

/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
*/

@end
