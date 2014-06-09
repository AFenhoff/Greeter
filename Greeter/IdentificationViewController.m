//
//  IdentificationViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 3/10/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "IdentificationViewController.h"
#import "Common.h"
#import "LicenseDecoder.h"

//#define LOG_FILE


@interface IdentificationViewController ()

@end

@implementation IdentificationViewController

@synthesize lastNameTextField, supplierNameTextField, dtDevices, lineaLabel;

bool scanActive=false;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	//update display according to current dtdev state
    [self connectionState:dtDevices.connstate];
}
- (void)viewDidLoad
{
    dtDevices = [DTDevices sharedDevice];
	dtDevices.delegate = self;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [dtDevices connect];
   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [dtDevices disconnect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)lastNameSearch:(id)sender
{
    [self searchByLastNameOrBarcode:lastNameTextField.text];
}

-(void)searchByLastNameOrBarcode:(NSString *)lastNameOrBarcode
{
    if([lastNameOrBarcode length] == 0)
    {
        [Common showAlert:@"Please enter Last Name" forDelegate:self];
        [lastNameTextField becomeFirstResponder];
        return;
    }
    
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    sharedObjects.dataManager.delegate = self;
    [sharedObjects.dataManager getSuppliersByLastName:lastNameOrBarcode forDelegate:self];
    
}

-(void)dataDidSync:(id)sender
{
    //If search by last name
    
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    if (sharedObjects.selectedSupplier)
    {
        [self performSegueWithIdentifier:@"SupplierFound" sender:self];
    }else{
        [self performSegueWithIdentifier:@"NameSearch" sender:self];
    }

    //if search by supplier name
    //[self performSegueWithIdentifier:@"SuppleirSearch" sender:self];
}

-(IBAction)supplierNameSearch:(id)sender
{
    if([supplierNameTextField.text length] == 0)
    {
        [Common showAlert:@"Please enter Last Name" forDelegate:self];
        [lastNameTextField becomeFirstResponder];
        return;
    }
    
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    sharedObjects.dataManager.delegate = self;
    [sharedObjects.dataManager getSuppliersBySupplierName:supplierNameTextField.text forDelegate:self];

}


#pragma LINEA methods
-(NSString *)getLogFile
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"log.txt"];
}

-(void)debug:(NSString *)text
{
	NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"HH:mm:ss:SSS"];
	NSString *timeString = [dateFormat stringFromDate:[NSDate date]];
	
	if([debug length]>10000)
		[debug setString:@""];
	[debug appendFormat:@"%@-%@\n",timeString,text];
    
	//[debugText setText:debug];
#ifdef LOG_FILE
	[debug writeToFile:[self getLogFile]  atomically:YES];
#endif
}

//DTDevice delegate method
-(void)connectionState:(int)state {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterLongStyle];
    
	switch (state) {
		case CONN_DISCONNECTED:
		case CONN_CONNECTING:
			//[statusImage setImage:[UIImage imageNamed:@"disconnected.png"]];
			[lineaLabel setText:[NSString stringWithFormat:@"Device is disconnected.\nSDK: ver %d.%d (%@)",dtDevices.sdkVersion/100,dtDevices.sdkVersion%100,[dateFormat stringFromDate:dtDevices.sdkBuildDate]]];
			//[batteryButton setHidden:TRUE];
			//[scanButton setHidden:TRUE];
			//[printButton setHidden:TRUE];
			break;
		case CONN_CONNECTED:
            [debug deleteCharactersInRange:NSMakeRange(0,debug.length)];
            //debugText.text=@"";
            scanActive=false;
			//[statusImage setImage:[UIImage imageNamed:@"connected.png"]];
			lineaLabel.text = [NSString stringWithFormat:@"SDK: ver %d.%d (%@)\n%@ %@ connected\nHardware revision: %@\nFirmware revision: %@\nSerial number: %@",dtDevices.sdkVersion/100,dtDevices.sdkVersion%100,[dateFormat stringFromDate:dtDevices.sdkBuildDate],dtDevices.deviceName,dtDevices.deviceModel,dtDevices.hardwareRevision,dtDevices.firmwareRevision,dtDevices.serialNumber];
			//[lineaLabel.text  setText:status];
            
			//[scanButton setHidden:FALSE];
            //if([dtDevices getSupportedFeature:FEAT_BLUETOOTH error:nil]!=FEAT_UNSUPPORTED)
            //    [printButton setHidden:FALSE];
            
            //[self updateBattery];
            
            //update pinpad display
            
            //ABF - MAY NEED THIS ONE
            //[self positionChanged:position];
            
			break;
	}
}


//DTDevice delegate method
-(void)barcodeData:(NSString *)barcode type:(int)type
{
    //If this is a vehicle barcode
    if([[barcode  substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"DJV"])
    {
        
        [Common showAlert:[NSString stringWithFormat:@"Vehicle barcode: %@", barcode] forDelegate:self];
        return;
    }
    
    //If this is a loyalty card
    if([[barcode  substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"%"])
    {
        [self searchByLastNameOrBarcode:barcode];
        return;
    }
    
    
    //[Common showAlert:barcode forDelegate:self];
    LicenseDecoder *ld = [[LicenseDecoder alloc] init];

    [ld decode2DBarcode:barcode];
    
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    sharedObjects.dataManager.delegate = self;
    [sharedObjects.dataManager getSupplierByIDNumber:ld.ID andState:ld.State forDelegate:self];
    
}

//DTDevice delegate method
-(void)magneticCardData:(NSString *)track1 track2:(NSString *)track2 track3:(NSString *)track3
{
    /*
     TRACK1
     %OHCINCINNATI^FENHOFF$ANDREW$B$^8582 CLOUGH PIKE^?
     TRACK2
     ;6360231813033791=151219781230?
     TRACK3
     %10452442682  D A             1507160BROBLU                          T))*M^     ?
    */
    LicenseDecoder *ld = [[LicenseDecoder alloc] init];
    [ld decodeMagStripeTracks:track1 withTrack2:track2 andTrack3:track3];
    
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    sharedObjects.dataManager.delegate = self;
    [sharedObjects.dataManager getSupplierByIDNumber:ld.ID andState:ld.State forDelegate:self];
    
}

@end
