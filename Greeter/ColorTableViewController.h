//
//  ColorTableViewController.h
//  YardOps
//
//  Created by Andrew Fenhoff on 6/11/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseModalViewController.h"

@interface ColorTableViewController : BaseTableViewController

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSString *selectedColor;

@end
