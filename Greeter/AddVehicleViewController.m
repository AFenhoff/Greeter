//
//  AddVehicleViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 6/11/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "AddVehicleViewController.h"
#import "ColorTableViewController.h"
#import "SearchViewController.h"
#import "DTDevices.h"

@interface AddVehicleViewController ()

@end

@implementation AddVehicleViewController

@synthesize makeButton, modelButton, colorButton, yearTextField, plateTextField, plateStateTextField,
trailerTextField, trailerStateTextField, barcodeTextField, processLineaCommands;

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
}

- (void) viewDidAppear:(BOOL)animated
{
    ((DTDevices *)[DTDevices sharedDevice]).delegate = self;
    SharedObjects* object = [SharedObjects getSharedObjects];
    object.selectedVehicle = (Vehicle *)[NSEntityDescription insertNewObjectForEntityForName:@"Vehicle" inManagedObjectContext:object.managedObjectContext];
    object.selectedVehicle.make = @"";
    object.selectedVehicle.model = @"";
    object.selectedVehicle.color = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"makeSegue"]) {
        SearchViewController* controller = (SearchViewController *)[segue destinationViewController];
    }
}


-(void)barcodeData:(NSString *)barcode type:(int)type
{
    if(!processLineaCommands) { return; }
    barcodeTextField.text = barcode;
}


-(void)modalComplete:(id)sender
{
}

-(IBAction)savePressed:(id)sender
{
    if ([self isValid]) {
        SharedObjects* object = [SharedObjects getSharedObjects];
        object.selectedVehicle.year = [NSNumber numberWithInt:[self.yearTextField.text intValue]];
        object.selectedVehicle.licensePlate = [self.plateTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        object.selectedVehicle.trailerNumber = [self.trailerTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        object.selectedVehicle.state = [self.plateStateTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        object.selectedVehicle.barcode = [self.barcodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [object.dataManager saveSupplierVehicle];
    }
}

-(BOOL)isValid
{
    BOOL result = YES;
    NSString* errorMessage = @"";
    SharedObjects* object = [SharedObjects getSharedObjects];
    
    self.plateTextField.text = [self.plateTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self.plateTextField.text isEqualToString:@""]) {
        result = NO;
        errorMessage = [errorMessage stringByAppendingString:@"License Plate is Required!\n"];
    }
    
    /*
    if ([object.selectedVehicle.make isEqualToString:@""]) {
        result = NO;
        errorMessage = [errorMessage stringByAppendingString:@"Make is Required!\n"];
    }
    
    if ([object.selectedVehicle.model isEqualToString:@""]) {
        result = NO;
        errorMessage = [errorMessage stringByAppendingString:@"Model is Required!\n"];
    }
    */
    if ([object.selectedVehicle.color isEqualToString:@""]) {
        result = NO;
        errorMessage = [errorMessage stringByAppendingString:@"Color is Required!\n"];
    }
    
    if (!result) {
        [Common showAlert:errorMessage forDelegate:self];
    }
    
    return result;
}

-(void)recordCreatedSuccessfully:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

bool isMake;

-(void)makePressed:(id)sender
{
    isMake = true;
    [self performSegueWithIdentifier:@"makeSegue" sender:self];
}

-(void)modelPressed:(id)sender
{
    isMake = false;
    [self performSegueWithIdentifier:@"makeSegue" sender:self];
}

@end
