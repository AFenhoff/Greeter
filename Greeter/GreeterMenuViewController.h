//
//  MasterViewController.h
//  Greeter
//
//  Created by Andrew Fenhoff on 9/20/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <CoreData/CoreData.h>

@interface GreeterMenuViewController : UITableViewController <NSFetchedResultsControllerDelegate>

//@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
