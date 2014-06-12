//
//  SelectMakeViewController.h
//  YardOps
//
//  Created by loaner on 6/12/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseModalViewController.h"

@interface SelectMakeViewController : BaseModalViewController<UISearchBarDelegate>
{
    NSArray* dataSource;
}

-(void)filterMakesForText:(NSString *) searchString;

@end
