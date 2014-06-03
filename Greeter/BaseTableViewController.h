//
//  BaseTableViewController.h
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 6/6/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "SharedObjects.h"

@interface BaseTableViewController : UITableViewController <DataManagerDelegate>

@property (nonatomic, retain) IBOutlet UIBarButtonItem  *syncButton;
//@property (nonatomic, retain) User *currentUser;
@property (nonatomic, retain) AppDelegate *appDelegate;

- (IBAction)syncButtonClicked:(id)sender;

-(void)refreshTitle;

@end
