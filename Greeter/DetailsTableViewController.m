//
//  DetailsTableViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 10/9/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "DetailsTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AdjustmentsViewController.h"

@interface DetailsTableViewController ()

@end

@implementation DetailsTableViewController

@synthesize tableView, camera, adjustmentLbs, adjustmentPct, imageCount;

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
    [self initCamera];
}

- (void)initCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        return;
    }
        
    if (!camera) {camera = [[UIImagePickerController alloc] init];}
    
    CGFloat navigationBarHeight = camera.navigationBar.bounds.size.height + 25;
    CGFloat height = camera.view.bounds.size.height - 2 * navigationBarHeight;
    CGFloat width = camera.view.bounds.size.width;
    CGRect f = CGRectMake(0, navigationBarHeight, width, height);
    CGFloat barHeight = (f.size.height - f.size.width) / 2;
    UIGraphicsBeginImageContext(f.size);
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7] set];
    UIRectFillUsingBlendMode(CGRectMake(0, 0, f.size.width, barHeight), kCGBlendModeNormal);
    UIRectFillUsingBlendMode(CGRectMake(0, f.size.height - barHeight, f.size.width, barHeight - 4), kCGBlendModeNormal);
    UIImage *overlayImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *overlayIV = [[UIImageView alloc] initWithFrame:f];
    // Disable all user interaction on overlay
    [overlayIV setUserInteractionEnabled:NO];
    [overlayIV setExclusiveTouch:NO];
    [overlayIV setMultipleTouchEnabled:NO];
    // Map generated image to overlay
    overlayIV.image = overlayImage;
    // Present Picker
    camera.modalPresentationStyle = UIModalPresentationCurrentContext;
    camera.delegate = self;
    camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        camera.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    camera.cameraOverlayView = overlayIV;
    //[self presentViewController:camera animated:YES completion:nil];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: //ID
            cell.textLabel.text =@"Capture Photo";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Images Captured: %d", imageCount];
            cell.backgroundColor = [UIColor clearColor];
            break;
        case 1: //Adjustment
            cell.textLabel.text = @"Deduct Weight";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d LBS  (%d%%)", adjustmentLbs, adjustmentPct];
            cell.backgroundColor = [UIColor clearColor];
            break;
/*
        case 2: //Docs
            cell.textLabel.text = @"Documentation";
            cell.detailTextLabel.text = @"NONE ON FILE";
            cell.backgroundColor = [UIColor redColor];
            break;
        case 3: //Vehicle Info
            cell.textLabel.text = @"Hauling Vehicle";
            cell.detailTextLabel.text = @"OH - FTR 34298";
            break;
        case 4: //Material
            cell.textLabel.text =  @"Material";
            cell.detailTextLabel.text = @"Autos - Whole";
            cell.backgroundColor = [UIColor clearColor];
            break;
        case 5: //Material
            cell.textLabel.text =  @"VINs";
            cell.detailTextLabel.text = @"1 captured";
            cell.backgroundColor = [UIColor clearColor];
            break;
 */
        default:
            break;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: //Photo Capture
            //[self performSegueWithIdentifier:@"idMenu" sender:self];
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                [Common showAlert:@"Camera Not Available" forDelegate:self];
                return;
            }
            
            [self.navigationController presentViewController:camera animated:YES completion:nil];
            break;
        case 1: //Adjustments
            [self performSegueWithIdentifier:@"adjustmentSegue" sender:self];
            break;
        case 2: //Docs
            [self performSegueWithIdentifier:@"documentationMenu" sender:self];
            break;
        case 3: //Vehicle Info
            break;
        case 4: //Material
            break;
        case 5: //VINs
            [self performSegueWithIdentifier:@"vinEntry" sender:self];
            break;
        default:
            break;
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[AdjustmentsViewController class]])
    {
        ((AdjustmentsViewController *)segue.destinationViewController).delegate = self;
        ((AdjustmentsViewController *)segue.destinationViewController).originalWeight = 28050;
    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [camera dismissViewControllerAnimated:YES completion:nil];
    //SAVE the image in info to the jpegger database
    //[info objectForKey:UIImagePickerControllerEditedImage];

}

-(void)modalCanceled:(id)sender
{
    
}

-(void)modalComplete:(id)sender
{
    adjustmentLbs = ((AdjustmentsViewController *)sender).adjustmentLbs;
    adjustmentPct = ((AdjustmentsViewController *)sender).adjustmentPercent;
    
    [tableView reloadData];
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
