//
//  VehicleMenuViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 3/12/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "VehicleMenuViewController.h"
#import "SearchViewController.h"
#import "Vehicle.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
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
    
    Vehicle *veh = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", veh.color, veh.year == 0 ? @"" : veh.year, veh.make, veh.model ];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", veh.state, veh.licensePlate];
    
    /*
     switch (indexPath.row) {
     case 0: //Vehicle Barcode
     cell.textLabel.text = @"ANDREW FENHOFF";
     break;
     case 1: //Loyalty Card
     cell.textLabel.text = @"CHUCK NORRIS";
     break;
     case 2: //ID
     cell.textLabel.text = @"GENGHIS KHAN";
     break;
     case 3: //Name (Supplier Or Person)
     cell.textLabel.text =  @"PETE ROSE";
     break;
     case 4: //Supplier No
     cell.textLabel.text =  @"NEIL ARMSTRONG";
     break;
     
     default:
     break;
     }
     */
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Save this info
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    sharedObjects.selectedVehicle = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate modalComplete:self];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"make" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    NSError *error = nil;
	
    if (_fetchedResultsController != nil) {
        [_fetchedResultsController.fetchRequest setSortDescriptors:sortDescriptors];
        [_fetchedResultsController performFetch:&error];
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Vehicle" inManagedObjectContext:sharedObjects.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:sharedObjects.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    //[Common updateSyncButtonText:syncButton inObjectContext:managedObjectContext];
    //[Common updateSyncButtonText:syncButton ForEntity:@"Vehicle" inObjectContext:_managedObjectContext];
    //[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    /*
     UITableView *tableView = self.tableView;
     
     switch(type) {
     case NSFetchedResultsChangeInsert:
     [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
     break;
     
     case NSFetchedResultsChangeDelete:
     [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     break;
     
     case NSFetchedResultsChangeUpdate:
     [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
     break;
     
     case NSFetchedResultsChangeMove:
     [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
     break;
     }
     */
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //[self.tableView endUpdates];
}


/*
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
 
 */

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

- (IBAction)newVehicle:(id)sender
{
    //Do some things and transition into new view control
    [self performSegueWithIdentifier:@"addVehicle" sender:self];
}

@end
