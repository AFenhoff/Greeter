//
//  QueueViewController.h
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 4/9/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface VINEntryViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,
UIActionSheetDelegate>


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITextField  *vinTextField;
@property (nonatomic, retain) IBOutlet UIButton  *saveButton;
@property                              int                  currentScanCount;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

-(IBAction)saveButtonPressed:(id)sender;
-(IBAction)doneButtonPressed:(id)sender;

@end
