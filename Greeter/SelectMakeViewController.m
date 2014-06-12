//
//  SelectMakeViewController.m
//  YardOps
//
//  Created by loaner on 6/12/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "SelectMakeViewController.h"

@interface SelectMakeViewController ()

@end

@implementation SelectMakeViewController

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
    [self filterMakesForText:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SharedObjects* object = [SharedObjects getSharedObjects];
    object.selectedVehicle.make = (NSString *)[dataSource objectAtIndex:indexPath.row];
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
        
        cell.textLabel.text = (NSString *)[dataSource objectAtIndex:indexPath.row];
    }
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    //[Common updateSyncButtonText:syncButton inObjectContext:managedObjectContext];
    //[Common updateSyncButtonText:syncButton ForEntity:@"Vehicle" inObjectContext:_managedObjectContext];
    //[self.tableView beginUpdates];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterMakesForText:searchText];
}

-(void)filterMakesForText:(NSString *) searchString
{
    if (searchString == nil) {
        searchString = @"";
    }
    
    dataSource = [self getDistinctMakes];
    
    
    if (![searchString isEqualToString:@""]) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", searchString];
        dataSource = [dataSource filteredArrayUsingPredicate:predicate];
    }
    
    [self.tableView reloadData];
}

-(NSArray *) getDistinctMakes
{
    SharedObjects* object = [SharedObjects getSharedObjects];
    NSManagedObjectContext *context = object.managedObjectContext;
    NSMutableArray* result =[[NSMutableArray alloc]init];
    
    /*
    NSEntityDescription *entity = [NSEntityDescription  entityForName:@"MakeAndModel" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setResultType:NSDictionaryResultType];
    [request setReturnsDistinctResults:YES];
    [request setPropertiesToFetch:@[@"make"]];
    */
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MakeAndModel"];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MakeAndModel" inManagedObjectContext:context];
    
    // Required! Unless you set the resultType to NSDictionaryResultType, distinct can't work.
    // All objects in the backing store are implicitly distinct, but two dictionaries can be duplicates.
    // Since you only want distinct names, only ask for the 'name' property.
    fetchRequest.resultType = NSDictionaryResultType;
    fetchRequest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"make"]];
    fetchRequest.returnsDistinctResults = YES;
    
    // Now it should yield an NSArray of distinct values in dictionaries.
    NSArray *dictionaries = [context executeFetchRequest:fetchRequest error:nil];
    
    // Execute the fetch.
    
    if (dictionaries == nil) {
        // Handle the error. 
    }
    
    NSLog (@"makes: %@",dictionaries);
    
    for (int index = 0; index < dictionaries.count; index++) {
        NSDictionary* temp = (NSDictionary *)[dictionaries objectAtIndex:index];
        NSString* value = (NSString *)[temp objectForKey:@"make"];
        [result addObject:value];
    }
    
    return [NSArray arrayWithArray:result];
}

@end
