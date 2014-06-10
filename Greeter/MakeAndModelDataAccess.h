//
//  MakeAndModelDataAccess.h
//  YardOps
//
//  Created by loaner on 6/10/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseDataAccess.h"
#import "ADFSViewController.h"
#import "SharedObjects.h"

@interface MakeAndModelDataAccess : BaseDataAccess<ADFSViewControllerDelegate>

-(void)getMakesAndModels:(id)delegate;

@end
