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
    //[self filterMaterialsForText:@""];
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
    MakeAndModel *selectedModels = (MakeAndModel *)[dataSource objectAtIndex:indexPath.row];
    
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    //sharedObjects.selectedMaterial = selectedModels;
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
        MakeAndModel *mat= (MakeAndModel *)[dataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = mat.model;
        //cell.detailTextLabel.text = mat.materialCode;
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
    
    NSEntityDescription *entity = [NSEntityDescription  entityForName:@"MakeAndModel" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setResultType:NSDictionaryResultType];
    [request setReturnsDistinctResults:YES];
    [request setPropertiesToFetch:@[@"make"]];
    
    // Execute the fetch.
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil) {
        // Handle the error. 
    }
    
    for (int index = 0; index; index++) {
        NSDictionary* temp = (NSDictionary *)[objects objectAtIndex:index];
        NSString* value = (NSString *)[temp objectForKey:@"make"];
        [result addObject:value];
    }
    
    return [NSArray arrayWithArray:result];
}

@end
