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

@interface IdentityDetailViewController ()

@end

@implementation IdentityDetailViewController

@synthesize tableView, finishButton, materialButton, documentsButton, vehicleButton, toolbar;
@synthesize vehicleOrIDRequired, allItemsComplete, syncButton, selectedSupplier;

bool _vehicleCaptured = NO;
bool _documentsCaptured = NO;
bool _materialCaptured = NO;

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
    [self allItemsAreComplete];
    
    /**************************************************************
     TODO: 
     Only turn Vehicle button red if vehicle required
     **************************************************************/
    if (vehicleOrIDRequired)
    {
        [self animateButtonToRed:vehicleButton];
    }


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
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"NAME";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", selectedSupplier.firstName, selectedSupplier.lastName];//@"ANDREW FENHOFF";
            break;
        case 1:
            cell.textLabel.text = @"SUPPLIER NAME";
            cell.detailTextLabel.text = selectedSupplier.supplierName;//@"N/A";
            break;
        case 2:
            cell.textLabel.text = @"ID NUMBER";
            cell.detailTextLabel.text = selectedSupplier.idNumber;//@"N/A";
            break;
        case 3:
            cell.textLabel.text = @"SUPPLIER TYPE";
            cell.detailTextLabel.text = [selectedSupplier.supplierType length] == 0 ? @"N/A" : selectedSupplier.supplierType;//@"PEDDLER (may have suppliers)";
            break;
        case 4:
            cell.textLabel.text = @"VEHICLE / ID REQUIRED";
            cell.detailTextLabel.text = [selectedSupplier.idRequired intValue] == 1 ? @"YES" : @"NO";
            break;
            
        default:
            break;
    }
    
}

-(void) animateButtonToRed:(UIBarButtonItem *)button
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    toolbar.backgroundColor = [UIColor redColor];
    [UIView commitAnimations];
}

-(IBAction)finishButtonPressed:(id)sender
{
    
    /***************************************************
     Save all information here
     ***************************************************/
     
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[GreeterHomeViewController class]]) {
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            break;
        }
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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
    [sharedObjects.dataManager getSupplierVehiclesBySupplierNo:selectedSupplier.supplierNo andIDNumber:selectedSupplier.idNumber forDelegate:self];
    
}

-(void)dataDidSync:(id)sender
{
    //DataManager's delegate method (dataDidSync) needs more info so we can determine which segue to fire
    [self performSegueWithIdentifier:@"vehicles" sender:self];
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
}

-(void)modalCanceled:(id)sender
{
    
}

-(void)allItemsAreComplete
{
    
    syncButton.enabled = _vehicleCaptured && _documentsCaptured && _materialCaptured;
    toolbar.backgroundColor = _vehicleCaptured && _documentsCaptured && _materialCaptured ? [UIColor grayColor] : [UIColor redColor];
}

@end
