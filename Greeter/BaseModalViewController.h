//
//  BaseModalViewController.h
//  YardOps
//
//  Created by Andrew Fenhoff on 3/19/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseViewController.h"
#import "SharedObjects.h"
#import "DataManager.h"

@protocol BaseModalViewControllerDelegate<NSObject>

@optional
-(void)modalCanceled:(id)sender;

@required
-(void)modalComplete:(id)sender;
@end


@interface BaseModalViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<BaseModalViewControllerDelegate> delegate;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) AppDelegate *appDelegate;

- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end
