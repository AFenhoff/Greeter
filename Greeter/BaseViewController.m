//
//  BaseViewController.m
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 6/6/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "Common.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize syncButton, appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //Following lines of code put tap enabled header on top of view controller
	UIButton *titleLabel = [UIButton buttonWithType:UIButtonTypeCustom];
	titleLabel.titleLabel.font = [UIFont boldSystemFontOfSize:kNavBarTitleFontSize];
    NSString* title = [NSString stringWithFormat:@"%@ : %@",     [Common getStringSetting:kBranchSettingName],self.navigationItem.title];
	[titleLabel setTitle:title forState:UIControlStateNormal];
	titleLabel.frame = CGRectMake(0, 0, 120, 44);
	[titleLabel addTarget:self action:@selector(titleTap:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.titleView = titleLabel;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    appDelegate.dataManager.delegate = self;


}

- (IBAction)syncButtonClicked:(id)__unused sender
{
//    appDelegate.dataManager.delegate = self;
//    [appDelegate.dataManager syncData];
}

-(void)dataDidSync:(id)sender
{
    [self viewDidAppear:YES];
}


- (IBAction) titleTap:(id)__unused sender
{
	[self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(User *)currentUser
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.currentUser;
}
*/
@end
