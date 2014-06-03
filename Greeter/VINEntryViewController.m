//
//  QueueViewController.m
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 4/9/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "VINEntryViewController.h"

@interface VINEntryViewController ()

@end

@implementation VINEntryViewController

@synthesize tableView, syncButton,vinTextField, saveButton, currentScanCount;//,managedObjectContext;


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
    [self loadTable];
}

-(void) viewDidAppear:(BOOL)animated
{
    //[Common updateSyncButtonText:syncButton inObjectContext:managedObjectContext];
    //[Common updateSyncButtonText:syncButton ForEntity:@"Vehicle" inObjectContext:managedObjectContext ];
}

-(void) loadTable
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //NSEntityDescription *entity = [NSEntityDescription entityForName:@"Vehicle" inManagedObjectContext:managedObjectContext];
    //[request setEntity:entity];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(status == 7)"];
    //[request setPredicate:predicate];
    
    NSError *error = nil;
    //NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    //if (mutableFetchResults == nil || mutableFetchResults.count == 0) {
    //    [Vehicle createVehiclesInManagedObjectContext:managedObjectContext];
    //    [self loadTable];
    //}			
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return YES;
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //If YMM is not in the object, use the color, bodyType and Comments
    if([[object valueForKey:@"year"] integerValue] == 0)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                               [[object valueForKey:@"color"] description],
                               [[object valueForKey:@"vehicleBodyType"] description]];
        
        cell.detailTextLabel.text = [[object valueForKey:@"comments"] description];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@",
                               [[object valueForKey:@"year"] description],
                               [[object valueForKey:@"make"] description],
                               [[object valueForKey:@"model"] description]];
        
        cell.detailTextLabel.text = [[object valueForKey:@"vin"] description];
    }
    
    if (![object valueForKey:@"hasBeenSynced"])
    {
        cell.backgroundColor = [UIColor redColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
     NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
     self.detailViewController.detailItem = object;
     }
     */
    
    
    switch (indexPath.row) {
        case 1: //Color
            
            break;
        case 2: //Type
            
        default:
            break;
    }
    
    
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    //NSEntityDescription *entity = [NSEntityDescription entityForName:@"Vehicle" inManagedObjectContext:self.managedObjectContext];
    //[fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"year" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    //NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    //aFetchedResultsController.delegate = self;
    //self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
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
    //[Common updateSyncButtonText:syncButton ForEntity:@"Vehicle" inObjectContext:managedObjectContext];
    [self.tableView beginUpdates];
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
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     /*
     VINOverrideViewController *vovc = (VINOverrideViewController *)segue.destinationViewController;
     vovc.managedObjectContext = managedObjectContext;
     vovc.fetchedResultsController = _fetchedResultsController;
     vovc.delegate = self;
     vovc.vin = vinTextField.text;
     */
 }


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    [self decodeVINAndSaveVehicle];
    return YES;
}

-(IBAction)saveButtonPressed:(id)sender
{
    [self decodeVINAndSaveVehicle];
}

-(void)decodeVINAndSaveVehicle
{
    if([self vinIsValidFormat])
    {
        
        // It would be nice to replace this with a lazily loaded property
        //VehicleDataAccess *vda = [[VehicleDataAccess alloc] init];
        //vda.delegate = self;
        //[vda decodeVIN:vinTextField.text withManagedObject:managedObjectContext];
        
    }
}

-(BOOL) vinIsValidFormat
{
    if([vinTextField.text.uppercaseString isEqualToString:@"BADVIN"]){
        //[vinTextField resignFirstResponder];
        //[Common showActionSheet:@"Unable to decode VIN.\nWould you like to override?"withDelegate:self inView:self.view withOtherButtons:@"Yes"];
        return NO;
    }
    return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self performSegueWithIdentifier:@"overrideVin" sender:self];
        
    }
}

/*
-(void)vinDidDecode:(Vehicle *)vehicle
{
    [tableView reloadData];
    [Common updateSyncButtonText:syncButton inObjectContext:managedObjectContext];
    //[Common updateSyncButtonText:syncButton ForEntity:@"Vehicle" inObjectContext:managedObjectContext ];
    currentScanCount++;
    //TODO move 5 to device setting
    if(currentScanCount > 5)
    {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.dataManager.delegate = self;
        [appDelegate.dataManager syncData];
        currentScanCount = 0;
    }
}
 */

/*
-(void)vehicleAdded:(Vehicle *)newVehicle
{
    [self.tableView reloadData];
}
*/

-(void)doneButtonPressed:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
