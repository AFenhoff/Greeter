//
//  IdentityDetailViewController.h
//  YardOps
//
//  Created by Andrew Fenhoff on 3/10/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseModalViewController.h"
#import "Supplier.h"

@interface IdentityDetailViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, BaseModalViewControllerDelegate>


@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *materialButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *documentsButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *vehicleButton;
@property (nonatomic, retain) IBOutlet UIButton *finishButton;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) Supplier *selectedSupplier;

@property (nonatomic) BOOL vehicleOrIDRequired;
@property (nonatomic) BOOL allItemsComplete;

-(IBAction)finishButtonPressed:(id)sender;

@end

