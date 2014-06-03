//
//  SelectMaterialTableViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 3/26/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "SelectMaterialTableViewController.h"

@interface SelectMaterialTableViewController ()

@end

@implementation SelectMaterialTableViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

/*
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77.0;
}
*/

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
    
    /******************************************************************
     TODO:
     This list should be ordered by most used material
     Search should find first by BeginsWith then by Contains
     ******************************************************************/
    
    switch (indexPath.row) {
        case 0: //Vehicle Barcode
            cell.textLabel.text = @"Autos - Crushed";
            cell.detailTextLabel.text = @"1000";
            break;
        case 1: //Loyalty Card
            cell.textLabel.text = @"Mixed Cast";
            cell.detailTextLabel.text = @"2610";
            break;
        case 2: //ID
            cell.textLabel.text = @"Sheet Iron";
            cell.detailTextLabel.text = @"1020";
            break;
        default:
            break;
    }
    
}

@end
