//
//  SearchViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 4/9/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "SearchViewController.h"
#import "MakeAndModel.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize destinationSearchBar;
//@synthesize searchTableView;
@synthesize managedObjectContext;
@synthesize sortBy, entityName;


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
    managedObjectContext = ((BaseViewController *)self).appDelegate.managedObjectContext;
    
    // Do any additional setup after loading the view.
    // NSFetchRequest needed by the fetchedResultsController
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // NSSortDescriptor tells defines how to sort the fetched results
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortBy ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // fetchRequest needs to know what entity to fetch
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    
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


- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    
    // We use an NSPredicate combined with the fetchedResultsController to perform the search
    if (self.destinationSearchBar.text !=nil)
    {
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"%@ contains[cd] %@", sortBy, self.destinationSearchBar.text];
        [fetchedResultsController.fetchRequest setPredicate:predicate];
    }
    else
    {
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"All"];
        [fetchedResultsController.fetchRequest setPredicate:predicate];
    }
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        // Handle error
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    // this array is just used to tell the table view how many rows to show
    fetchedObjects = fetchedResultsController.fetchedObjects;
    
    // dismiss the search keyboard
    [destinationSearchBar resignFirstResponder];
    
    // reload the table view
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //   TODO need to figure out how to tell this controller which object to create
    //      make vs model, etc
    MakeAndModel *make = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = make.make;
    
    return cell;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortBy ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    NSError *error = nil;
	
    if (_fetchedResultsController != nil) {
        [_fetchedResultsController.fetchRequest setSortDescriptors:sortDescriptors];
        [_fetchedResultsController performFetch:&error];
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
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

@end
