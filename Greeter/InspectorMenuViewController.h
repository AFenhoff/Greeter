//
//  InspectorMenuViewController.h
//  YardOps
//
//  Created by Andrew Fenhoff on 10/9/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "BaseViewController.h"

@interface InspectorMenuViewController : BaseViewController <UITableViewDelegate>


@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) IBOutlet UIButton *ticketSearchButton;

-(IBAction)ticketSearchButtonPressed:(id)sender;

@end
