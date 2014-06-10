//
//  SelectMaterialTableViewController.h
//  YardOps
//
//  Created by Andrew Fenhoff on 3/26/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseModalViewController.h"
#import "Material.h"

@interface SelectMaterialTableViewController : BaseModalViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
