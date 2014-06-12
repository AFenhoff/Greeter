//
//  ColorTableViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 6/11/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "ColorTableViewController.h"

@interface ColorTableViewController ()

@end

@implementation ColorTableViewController

@synthesize selectedColor;

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
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    switch (indexPath.row) {
        case 0:
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.text =  @"WHITE";
            break;
        case 1:
            cell.backgroundColor = [UIColor blackColor];
            cell.textLabel.text =  @"BLACK";
            cell.textLabel.textColor = [UIColor whiteColor];
            break;
        case 2:
            cell.backgroundColor = [UIColor redColor];
            cell.textLabel.text =  @"RED";
            cell.textLabel.textColor = [UIColor whiteColor];
            break;
        case 3:
            cell.backgroundColor = [UIColor grayColor];
            cell.textLabel.text =  @"GRAY";
            break;
        case 4:
            cell.backgroundColor = [UIColor orangeColor];
            cell.textLabel.text =  @"ORANGE";
            cell.textLabel.textColor = [UIColor whiteColor];
            break;
        case 5:
            cell.backgroundColor = [UIColor greenColor];
            cell.textLabel.text = @"GREEN";
            break;
        case 6:
            cell.backgroundColor = [UIColor colorWithRed:(192.0f/255.0f) green:(192.0f/255.0f) blue:(192.0f/255.0f) alpha:1.0f];
            cell.textLabel.text = @"SILVER";
            break;
        case 7:
            //255,165,0
            cell.backgroundColor = [UIColor colorWithRed:1.0f green:(165.0f/255.0f) blue:0.0f alpha:1.0f];
            cell.textLabel.text = @"GOLD";
            break;
        case 8:
            cell.backgroundColor = [UIColor blueColor];
            cell.textLabel.text =  @"BLUE";
            cell.textLabel.textColor = [UIColor whiteColor];
            break;
        case 9:
            cell.backgroundColor = [UIColor brownColor];
            cell.textLabel.text =  @"BROWN";
            cell.textLabel.textColor = [UIColor whiteColor];
            break;
        case 11:
            cell.backgroundColor = [UIColor yellowColor];
            cell.textLabel.text =  @"YELLOW";
            break;
        case 12:
            cell.backgroundColor = [UIColor purpleColor];
            cell.textLabel.text =  @"PURPLE";
            cell.textLabel.textColor = [UIColor whiteColor];
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SharedObjects* object = [SharedObjects getSharedObjects];
    if (object.selectedVehicle == nil) {
        object.selectedVehicle = [[Vehicle alloc]init];
    }
    object.selectedVehicle.color = [[tableView cellForRowAtIndexPath:indexPath].textLabel.text uppercaseString];
    [self.delegate modalComplete:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
