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

@synthesize lastNameTextField, supplierNameTextField, dtDevices, lineaLabel, processLineaCommands;

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
	[dtDevices connect];
}

- (void)viewDidAppear:(BOOL)animated
{
//too many disconnects and reconnects causes application to crash
//problem is in eaClean method in dtDeviceManager library
//    dtDevices = [DTDevices sharedDevice];
//	  dtDevices.delegate = self;
//    [dtDevices connect];
// 	  dtDevices.delegate = self;
    //We have to set this here because messing around with the delegate on dtDevices
    //crashes the application. The bug is in the Linea SDK
    processLineaCommands = YES;
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    [sharedObjects clearData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //We have to set this here because messing around with the delegate on dtDevices
    //crashes the application. The bug is in the Linea SDK
    processLineaCommands = NO;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//too many disconnects and reconnects causes application to crash
//problem is in eaClean method in dtDeviceManager library
//    dtDevices = [DTDevices sharedDevice];
// 	  dtDevices.delegate = self;
//    [dtDevices disconnect];
//      dtDevices.delegate = nil;
    //We have to set this here because messing around with the delegate on dtDevices
    //crashes the application. The bug is in the Linea SDK
    processLineaCommands = NO;
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
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    //If search by last name

    switch (((DataManager *)sender).callType) {
        case LastNameSearch:
            if (sharedObjects.foundSupplierCount == 0)
            {
                [Common showAlert:@"No suppliers found." forDelegate:self];
                return;
            }
            [self performSegueWithIdentifier:@"NameSearch" sender:self];
            break;
        case SupplierNameSearch:
            if (sharedObjects.foundSupplierCount == 0)
            {
                [Common showAlert:@"No suppliers found." forDelegate:self];
                return;
            }
            [self performSegueWithIdentifier:@"SupplierFound" sender:self];
            break;
        case SupplierIDSearch:
            if(sharedObjects.foundSupplierCount == 0)
            {
                Supplier *supp = (Supplier *)[NSEntityDescription insertNewObjectForEntityForName:@"Supplier" inManagedObjectContext:sharedObjects.managedObjectContext];
                
                supp.supplierName   = @"Peddler (No Acct)";
                supp.supplierNo     = @"******";
                supp.supplierType   = @"P";
                //supp.cfcExpDate     = ;
                supp.idNumber       = sharedObjects.scannedLicense.ID;
                supp.idPhoto        = 0;
                supp.idRequired     = [NSNumber numberWithInt:1];
                supp.fingerPrint    = 0;
                supp.firstName      = sharedObjects.scannedLicense.FirstName;
                supp.lastName       = sharedObjects.scannedLicense.LastName;
                supp.rowid          = 0;
                
                NSError *error = nil;
                if (![sharedObjects.managedObjectContext save:&error]) {
                    // Handle the error.
                }
                sharedObjects.selectedSupplier = supp;
                
            }
            [self performSegueWithIdentifier:@"SupplierFound" sender:self];
            break;
        default:
            break;
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
            lineaLabel.backgroundColor = [UIColor redColor];
            lineaLabel.textColor = [UIColor whiteColor];
			//[batteryButton setHidden:TRUE];
			//[scanButton setHidden:TRUE];
			//[printButton setHidden:TRUE];
			break;
		case CONN_CONNECTED:
            [debug deleteCharactersInRange:NSMakeRange(0,debug.length)];
            //debugText.text=@"";
            scanActive=false;
			//[statusImage setImage:[UIImage imageNamed:@"connected.png"]];
			lineaLabel.text = [NSString stringWithFormat:@"%@ %@ connected\nHardware revision: %@\nFirmware revision: %@\nSerial number: %@",dtDevices.deviceName,dtDevices.deviceModel,dtDevices.hardwareRevision,dtDevices.firmwareRevision,dtDevices.serialNumber];
			lineaLabel.backgroundColor = [UIColor clearColor];
            lineaLabel.textColor = [UIColor blackColor];
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
    if(!processLineaCommands) { return; }
    
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
    if(ld.ID)
    {
        SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
        sharedObjects.dataManager.delegate = self;
        [sharedObjects.dataManager getSupplierByIDNumber:ld.ID andState:ld.State forDelegate:self];
    }else{
        [self searchByLastNameOrBarcode:barcode];
    }
    
}

/*
-(void)barcodeData:(NSString *)barcode isotype:(NSString *)isotype
{
    [Common showAlert:[NSString stringWithFormat:@"Vehicle barcode: %@", barcode] forDelegate:self];

}

-(void)barcodeNSData:(NSData *)barcode type:(int)type
{
    [Common showAlert:[NSString stringWithFormat:@"Vehicle barcode: %@", barcode] forDelegate:self];
    
}

-(void)barcodeNSData:(NSData *)barcode isotype:(NSString *)isotype
{
    [Common showAlert:[NSString stringWithFormat:@"Vehicle barcode: %@", barcode] forDelegate:self];
    
}
*/

//DTDevice delegate method
-(void)magneticCardData:(NSString *)track1 track2:(NSString *)track2 track3:(NSString *)track3
{
    
    if(!processLineaCommands) { return; }
    
    int sound[]={2730,150,0,30,2730,150};
	[dtDevices playSound:100 beepData:sound length:sizeof(sound) error:nil];
	
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

-(IBAction)reconnectDevices:(id)sender
{
    dtDevices = [DTDevices sharedDevice];
	dtDevices.delegate = self;
    [dtDevices disconnect];
    [dtDevices connect];

}

@end
