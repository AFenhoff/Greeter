//
//  DetailsTableViewController.h
//  YardOps
//
//  Created by Andrew Fenhoff on 10/9/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "BaseModalViewController.h"

@interface DetailsTableViewController : BaseTableViewController <UIImagePickerControllerDelegate, BaseModalViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UIImagePickerController *camera;
@property (nonatomic) NSInteger imageCount;
@property (nonatomic) NSInteger adjustmentLbs;
@property (nonatomic) NSInteger adjustmentPct;

@end
