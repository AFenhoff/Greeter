//
//  SearchViewController.h
//  YardOps
//
//  Created by Andrew Fenhoff on 4/9/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseModalViewController.h"

@interface SearchViewController : BaseModalViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate>

{
    UISearchBar *destinationSearchBar;
//    UITableView *searchTableView;
    
    
    NSFetchedResultsController  *fetchedResultsController;
    NSManagedObjectContext      *managedObjectContext;
    
    NSArray *fetchedObjects;
    
    NSString *sortBy;
    NSString *entityName;
    
}

@property (nonatomic, retain) IBOutlet UISearchBar  *destinationSearchBar;
//@property (nonatomic, retain) IBOutlet UITableView  *searchTableView;

@property (nonatomic, retain) NSFetchedResultsController    *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext        *managedObjectContext;

@property (nonatomic, retain) NSString              *sortBy;
@property (nonatomic, retain) NSString              *entityName;

@end
