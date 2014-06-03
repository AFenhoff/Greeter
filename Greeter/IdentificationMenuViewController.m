//
//  IdentificationMenuViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 10/9/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "IdentificationMenuViewController.h"
#import "IdentificationViewController.h"

@interface IdentificationMenuViewController ()

@end

@implementation IdentificationMenuViewController

//@synthesize tableView;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    IdentificationViewController *idvc = (IdentificationViewController *)segue.destinationViewController;
    switch (indexPath.row) {
        case 0: //Vehicle Barcode
            //idvc.navigationItem.title = @"Vehicle";
            //idvc.titleLabel.text = @"Scan Vehicle Barcode";
            break;
        case 1: //Loyalty Card
            //idvc.navigationItem.title = @"Loyalty Card";
            //idvc.titleLabel.text = @"Scan Loyalty Card";
            break;
        case 2: //ID
            //idvc.navigationItem.title = @"ID";
            //idvc.titleLabel.text = @"Scan ID";
            break;
        case 3: //Name (Supplier Or Person)
            //idvc.navigationItem.title = @"Name";
            //idvc.titleLabel.text = @"Enter Supplier Name or Last Name";
            break;
        case 4: //Supplier No
            //idvc.navigationItem.title = @"Supplier";
            //idvc.titleLabel.text = @"Enter Supplier Number";
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: //Vehicle Barcode
            cell.textLabel.text = @"Vehicle Barcode";
            break;
        case 1: //Loyalty Card
            cell.textLabel.text = @"Loyalty Card";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"identification" sender:self];
    
}

@end
