//
//  SelectModelViewController.h
//  YardOps
//
//  Created by Andrew Fenhoff on 6/12/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseModalViewController.h"
#import "MakeAndModel.h"
#import "Common.h"

@interface SelectModelViewController : BaseModalViewController<NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (nonatomic, retain) IBOutlet UISearchBar  *destinationSearchBar;
@property (nonatomic, retain) NSArray* models;
@property (nonatomic, retain) NSString *make;

-(void)filterMaterialsForText:(NSString *) searchString;
@end
