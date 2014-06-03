//
//  DocumentationMenuTableViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 10/15/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "DocumentationMenuViewController.h"
#import "Common.h"
#import "BarcodeTableViewCell.h"

@interface DocumentationMenuViewController ()

@end

@implementation DocumentationMenuViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: //Vehicle Barcode
            cell.textLabel.text = @"CFC Contract";
            cell.detailTextLabel.text = @"EXP: May 25, 2015";
            cell.backgroundColor=[UIColor greenColor];
            break;
        case 1: //Loyalty Card
            cell.textLabel.text = @"Payment Authorization";
            cell.detailTextLabel.text = @"EXP: N/A";
            cell.backgroundColor=[UIColor redColor];
            break;
        case 2: //ID
            cell.textLabel.text = @"ID";
            break;
        case 3: //Name (Supplier Or Person)
            cell.textLabel.text =  @"Name";
            break;
        case 4: //Supplier No
            cell.textLabel.text =  @"Supplier Number";
            break;
            
        default:
            break;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
            
            [self performSegueWithIdentifier:@"documentSegue" sender:self];
            break;
            
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"documentSegue"])
    {
        NSLog(@"delegated");
        ((BarcodeViewController *)segue.destinationViewController).delegate = self;
    }
}


-(void)barcodeCaptured:(NSString *)barcode CallingViewController:(UIViewController *)callingViewController
{
    //[Common showAlert:[NSString stringWithFormat:@"Barcode Read: %@", barcode] forDelegate:self];
    //[callingViewController dismissViewControllerAnimated:YES completion:nil];
    ((BarcodeTableViewCell *)[self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow]).barcodeTextLabel.text= barcode;
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
