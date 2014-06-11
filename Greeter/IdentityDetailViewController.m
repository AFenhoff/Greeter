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
@synthesize vehicleOrIDRequired, allItemsComplete, syncButton;

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
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"NAME";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", sharedObjects.selectedSupplier.firstName, sharedObjects.selectedSupplier.lastName];//@"ANDREW FENHOFF";
            break;
        case 1:
            cell.textLabel.text = @"SUPPLIER NAME";
            cell.detailTextLabel.text = sharedObjects.selectedSupplier.supplierName;//@"N/A";
            break;
        case 2:
            cell.textLabel.text = @"ID NUMBER";
            cell.detailTextLabel.text = sharedObjects.selectedSupplier.idNumber;//@"N/A";
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
    //DataManager's delegate method (dataDidSync) needs more info so we can determine which segue to fire
    switch (((DataManager *)sender).callType) {
        case SupplierVehicles:
            [self performSegueWithIdentifier:@"vehicles" sender:self];
            break;
        case PostGreeterQueue:
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[GreeterHomeViewController class]]) {
                    [self.navigationController popToViewController:controller
                                                          animated:YES];
                    break;
                }
            }
            
            break;
        default:
            break;
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
}

-(void)modalCanceled:(id)sender
{
    
}

-(void)allItemsAreComplete
{
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    syncButton.enabled = _vehicleCaptured && _documentsCaptured && ((sharedObjects.greeterType == FE && _materialCaptured) || sharedObjects.greeterType == NF);
    //toolbar.backgroundColor = syncButton.enabled ? [UIColor grayColor] : [UIColor redColor];
    
    /**************************************************************
     TODO:
     Only turn Vehicle button red if vehicle required
     **************************************************************/
    if (!syncButton.enabled)
    {
        [self animateToolbarToColor:[UIColor redColor]];
    }else{
        [self animateToolbarToColor:[UIColor grayColor]];
    }

}

@end
