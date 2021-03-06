//
//  SelectMaterialTableViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 3/26/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "SelectMaterialTableViewController.h"

@interface SelectMaterialTableViewController ()

@end

@implementation SelectMaterialTableViewController
@synthesize materials;

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
    [self filterMaterialsForText:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.materials count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Material *selectedMaterial = (Material *)[self.materials objectAtIndex:indexPath.row];
    
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    sharedObjects.selectedMaterial = selectedMaterial;
    [self dismissViewControllerAnimated:TRUE completion:nil];
    [self.delegate modalComplete:self];
}

/*
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77.0;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    /******************************************************************
     TODO:
     This list should be ordered by most used material
     Search should find first by BeginsWith then by Contains
     ******************************************************************/
    
    if (indexPath.section == 0) {
        Material *mat= (Material *)[self.materials objectAtIndex:indexPath.row];
        cell.textLabel.text = mat.materialDescription;
        cell.detailTextLabel.text = mat.materialCode;
    }
    
}

- (NSFetchedResultsController *)fetchedResultsController
{
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"materialCode" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    NSError *error = nil;
	
    if (_fetchedResultsController != nil) {
        [_fetchedResultsController.fetchRequest setSortDescriptors:sortDescriptors];
        [_fetchedResultsController performFetch:&error];
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Material" inManagedObjectContext:sharedObjects.managedObjectContext];
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

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterMaterialsForText:searchText];
}

-(void)filterMaterialsForText:(NSString *) searchString
{
    if (searchString == nil) {
        searchString = @"";
    }
    
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    
    
    if (![searchString isEqualToString:@""]) {
        searchString = [searchString stringByAppendingString:@"*"];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"materialDescription LIKE[c] %@", searchString];
        [request setPredicate:predicate];
    }
    
    SharedObjects* sharedObject = [SharedObjects getSharedObjects];
    NSManagedObjectContext* context = sharedObject.managedObjectContext;
    NSEntityDescription* materialEntity = [NSEntityDescription entityForName:@"Material" inManagedObjectContext:context];
    
    [request setEntity:materialEntity];
    
    /*
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"materialCode" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    */
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array == nil)
    {
        //TODO: handle error
    }
    else
    {
        self.materials = array;
    }
    
    [self.tableView reloadData];
}

@end
