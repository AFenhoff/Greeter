//
//  YardOpsModeSelectTableViewController.m
//  YardOps
//
//  Created by loaner on 6/9/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "YardOpsModeSelectTableViewController.h"

@interface YardOpsModeSelectTableViewController ()

@end

@implementation YardOpsModeSelectTableViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        switch ([Common getIntSetting:kGreeterMode]) {
            case 1:
                //fe
                [self performSegueWithIdentifier:@"LoginGreeterAndFESelected" sender:self];
                break;
            case 2:
                //nf
                [self performSegueWithIdentifier:@"LoginGreeterAndNFSelected" sender:self];
                break;
            default:
                [self performSegueWithIdentifier:@"greeter" sender:self];
                break;
        }
    }
}
@end
