//
//  VehicleMenuViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 3/12/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "VehicleMenuViewController.h"
#import "SearchViewController.h"

@interface VehicleMenuViewController ()

@end

@implementation VehicleMenuViewController

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
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: //Vehicle Barcode
            cell.textLabel.text = @"Make";
            cell.detailTextLabel.text = @"Chevrolet";
            break;
        case 1: //Loyalty Card
            cell.textLabel.text = @"Model";
            cell.detailTextLabel.text = @"Silverado";
            break;
        case 2: //ID
            cell.textLabel.text = @"Year";
            cell.detailTextLabel.text = @"2001";
            break;
        case 3: //Color
            cell.textLabel.text = @"Color";
            cell.detailTextLabel.text = @"Silver";
            break;
        case 4: //Vehicle Plate
            cell.textLabel.text = @"Vehicle Plate";
            cell.detailTextLabel.text = @"OH - JDL 9926";
            break;
        case 5: //Trailer Plate
            cell.textLabel.text = @"Trailer Plate";
            cell.detailTextLabel.text = @"OH - WER 5489";
            break;
        case 6: //Scan barcode to save vehicle on file
            cell.textLabel.text = @"Barcode";
            cell.detailTextLabel.text = @"Press to Scan";
            break;
            
        default:
            break;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row);
    switch (indexPath.row) {
        case 0:
            
            [self performSegueWithIdentifier:@"makeSegue" sender:self];
            break;
        case 6:
            [self performSegueWithIdentifier:@"barcodeSegue" sender:self];
            break;
            
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"barcodeSegue"])
    {
        NSLog(@"delegated");
        ((BarcodeViewController *)segue.destinationViewController).delegate = self;
    }
    
    if([[segue identifier] isEqualToString:@"makeSegue"])
    {
        NSLog(@"delegated");
        // TODO will need this but delegation has not been set up yet
        //((SearchViewController *)segue.destinationViewController).delegate = self;
        ((SearchViewController *)segue.destinationViewController).sortBy = @"make";
        ((SearchViewController *)segue.destinationViewController).entityName = @"Make";
        
    }
    
    
    
}

-(void)barcodeCaptured:(NSString *)barcode CallingViewController:(UIViewController *)callingViewController
{
    //[Common showAlert:[NSString stringWithFormat:@"Barcode Read: %@", barcode] forDelegate:self];
    //[callingViewController dismissViewControllerAnimated:YES completion:nil];
    ((UITableViewCell *)[self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow]).detailTextLabel.text= barcode;
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

-(void)modalCanceled:(id)sender
{
    
}

-(void)modalComplete:(id)sender
{
    
}

@end
