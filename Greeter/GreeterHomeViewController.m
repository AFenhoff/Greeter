//
//  GreeterHomeViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 10/9/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "GreeterHomeViewController.h"
#import "SharedObjects.h"

@interface GreeterHomeViewController ()

@end

@implementation GreeterHomeViewController

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

-(void)viewDidAppear:(BOOL)animated
{
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    [sharedObjects clearData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)nfButtonPressed:(id)sender
{
    //[self performSegueWithIdentifier:@"details" sender:self];
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    sharedObjects.greeterType = NF;
}

-(IBAction)feButtonPressed:(id)sender
{
    //[self performSegueWithIdentifier:@"details" sender:self];
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    sharedObjects.greeterType = FE;
}


@end
