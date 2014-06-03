//
//  BaseViewController.h
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 6/6/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "AppDelegate.h"
#import "SharedObjects.h"

@interface BaseViewController : UIViewController <DataManagerDelegate>

@property (nonatomic, retain) IBOutlet UIBarButtonItem  *syncButton;
@property (nonatomic, retain) AppDelegate *appDelegate;

//@property (nonatomic, retain) User *currentUser;

@end
