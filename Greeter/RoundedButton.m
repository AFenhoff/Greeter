//
//  RoundedButton.m
//  YardOps
//
//  Created by Andrew Fenhoff on 10/9/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "RoundedButton.h"

@implementation RoundedButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 10; // this value vary as per your desire
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        self.titleLabel.textColor = [UIColor whiteColor];
    }
    
    return self;
}

-(void)awakeFromNib
{
    self.layer.cornerRadius = 10; // this value vary as per your desire
    self.clipsToBounds = YES;
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

@end
