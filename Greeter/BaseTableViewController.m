//
//  BaseTableViewController.m
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 6/6/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "BaseTableViewController.h"
#import "AppDelegate.h"
#import "SharedObjects.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

@synthesize syncButton, appDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIButton *titleLabel = [UIButton buttonWithType:UIButtonTypeCustom];
	titleLabel.titleLabel.font = [UIFont boldSystemFontOfSize:kNavBarTitleFontSize];
	NSString* title = [NSString stringWithFormat:@"%@: %@",     [Common getStringSetting:@"DefaultBranchCode"],self.navigationItem.title];
	[titleLabel setTitle:title forState:UIControlStateNormal];
	titleLabel.frame = CGRectMake(0, 0, 120, 44);
	[titleLabel addTarget:self action:@selector(titleTap:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.titleView = titleLabel;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.dataManager.delegate = self;
  
}

-(void)refreshTitle
{
    NSString* title = [NSString stringWithFormat:@"%@: %@",     [Common getStringSetting:@"DefaultBranchCode"],self.navigationItem.title];
    [((UIButton *)self.navigationItem.titleView) setTitle:title forState:UIControlStateNormal];
}

- (IBAction)syncButtonClicked:(id)sender
{
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.dataManager.delegate = self;
//    [appDelegate.dataManager syncData];
}

-(void)dataDidSync:(id)sender
{
    [self viewDidAppear:YES];
    [self.tableView reloadData];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat width = CGRectGetWidth(tableView.bounds) - 25;
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0,0,width,height)];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,0,width,height)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font= [UIFont boldSystemFontOfSize:12.0f];
    headerLabel.shadowOffset = CGSizeMake(1, 1);
    //headerLabel.shadowColor = [UIColor darkGrayColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    //NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    headerLabel.text = [NSString stringWithFormat:@"On Device: %@", sharedObjects.currentUser.userName];//title;
    [container addSubview:headerLabel];
    return container;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

/*
-(User *)currentUser
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.currentUser;
}
*/

@end
