//
//  SelectMaterialTableViewController.h
//  YardOps
//
//  Created by Andrew Fenhoff on 3/26/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseModalViewController.h"
#import "Material.h"

@interface SelectMaterialTableViewController : BaseModalViewController<NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSArray* materials;

-(void)filterMaterialsForText:(NSString *) searchString;

@end
