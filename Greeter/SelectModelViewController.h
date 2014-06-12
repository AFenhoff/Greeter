//
//  SelectModelViewController.h
//  YardOps
//
//  Created by Andrew Fenhoff on 6/12/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseModalViewController.h"
#import "MakeAndModel.h"

@interface SelectModelViewController : BaseModalViewController<NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (nonatomic, retain) NSArray* models;

-(void)filterMaterialsForText:(NSString *) searchString;
@end
