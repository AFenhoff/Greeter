//
//  LicenseDecoder.h
//  YardOps
//
//  Created by Andrew Fenhoff on 6/4/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LicenseDecoder : NSObject

    @property (nonatomic, retain) NSString *ID;
    @property (nonatomic, retain) NSString *FirstName;
    @property (nonatomic, retain) NSString *LastName;
    @property (nonatomic, retain) NSString *Address1;
    @property (nonatomic, retain) NSString *Address2;
    @property (nonatomic, retain) NSString *Zip;
    @property (nonatomic, retain) NSString *City;
    @property (nonatomic, retain) NSString *State;
    @property (nonatomic, retain) NSString *BirthDate;
    @property (nonatomic, retain) NSString *BirthDateStr;
    @property (nonatomic, retain) NSString *ExpirationDate;
    @property (nonatomic, retain) NSString *ExpirationDateStr;
    @property (nonatomic, retain) NSString *Gender;
    @property (nonatomic, retain) NSString *EyeColor;
    @property (nonatomic, retain) NSString *Height;
    @property (nonatomic, retain) NSString *DateIssued;
    @property (nonatomic, retain) NSString *HairColor;
    @property (nonatomic, retain) NSString *BirthPlace;
    @property (nonatomic, retain) NSString *Race;
    @property (nonatomic, retain) NSString *Weight;

-(NSString *)decodeMagStripeTracks:(NSString *)track1 withTrack2:(NSString *)track2 andTrack3:(NSString *)track3;

-(void)decode2DBarcode:(NSString *)barcode;

@end
