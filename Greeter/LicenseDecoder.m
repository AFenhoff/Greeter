//
//  LicenseDecoder.m
//  YardOps
//
//  Created by Andrew Fenhoff on 6/4/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "LicenseDecoder.h"
#import "NSString+ContainsString.h"
#import "SharedObjects.h"

@implementation LicenseDecoder

@synthesize ID,
            FirstName,
            LastName,
            Address1,
            Address2,
            Zip,
            City,
            State,
            BirthDate,
            BirthDateStr,
            ExpirationDate,
            ExpirationDateStr,
            Gender,
            EyeColor,
            Height,
            DateIssued,
            HairColor,
            BirthPlace,
            Race,
            Weight;

-(NSString *)decodeMagStripeTracks:(NSString *)track1
                        withTrack2:(NSString *)track2
                         andTrack3:(NSString *)track3
{
    NSString *errorString = @"";
    int firstCarrotPos = 0;
    int secondCarrotPos = 0;
    int thirdCarrotPos = 0;
    
    /************************************************************************************************************
        TRACK 1
     ************************************************************************************************************/
    //if([track1 doesNotContainInvalidCharacters]){
    if(track1)
    {
        State = [track1 substringWithRange:NSMakeRange(1, 2)];
        if([[track1 substringWithRange:NSMakeRange(3, 13) ] containsString:@"^"])
        {
            firstCarrotPos = [track1 rangeOfString:@"^"].location;
            City = [track1 substringWithRange:NSMakeRange(3, firstCarrotPos - 3)];
        }else{
            City = [track1 substringWithRange:NSMakeRange(3, 13)];
        }
        //May need to ensure City does not contain invalid characters
        
        int nameStartPos = 0;
        nameStartPos = firstCarrotPos > 0 ? firstCarrotPos + 1 : 17;
        
        secondCarrotPos = [[track1 substringWithRange:NSMakeRange(nameStartPos, 35)] containsString:@"^"] ? [[track1 substringWithRange:NSMakeRange(nameStartPos, 35)] rangeOfString:@"^"].location : 0;
        
        NSString *fullName = @"";
        fullName = secondCarrotPos > 0 ? [track1 substringWithRange:NSMakeRange(nameStartPos, secondCarrotPos + 1)]  : [track1 substringWithRange:NSMakeRange(nameStartPos, 35)];
        NSArray *nameParts = [fullName componentsSeparatedByString:@"$"];
        
        FirstName = nameParts[1];
        LastName = nameParts[0];
        //May need to ensure FirstName and LastName do not contain invalid characters
        
        int addressStartPos = 0;
        int addressLen = 0;
        NSString *fullAddress = @"";
        
        addressStartPos = secondCarrotPos > 0 ? nameStartPos + secondCarrotPos + 1 : nameStartPos + 35 + 1;
        addressLen = track1.length - addressStartPos < 29 ? track1.length - addressStartPos : 29;
        thirdCarrotPos = [[track1 substringWithRange:NSMakeRange(addressStartPos, addressLen)] containsString:@"^"] ? [[track1 substringWithRange:NSMakeRange(addressStartPos, addressLen)] rangeOfString:@"^"].location : 0;
        fullAddress = [track1 substringWithRange:NSMakeRange(addressStartPos, thirdCarrotPos)];
        NSArray *addressParts = [fullAddress componentsSeparatedByString:@"$"];
        
        Address1 = addressParts[0];
        Address2 = addressParts.count > 1 ? addressParts[1] : @"";
    }
    //May need to ensure Address1 and Address2 do not contain invalid characters

    //}else{ return "Track 1 contains invalid characters."
    /************************************************************************************************************
        END TRACK 1
     ************************************************************************************************************/
    
    /************************************************************************************************************
        TRACK 2
     ************************************************************************************************************/
    
    // THIS SHOULD BE SENT TO THE WEBSERVICE To DECODE SO THAT WE CAN HANDLE MORE GRACEFULLY AS NEW STATES ARE BROUGHT ONLINE
    if(track2)
    {
        int equalSignPos = 0;
        int lastEqualSignPos = 0;
        NSString *fullIDString = @"";
        equalSignPos = [[track2 substringWithRange:NSMakeRange(7, 13)] containsString:@"="] ? [track2 rangeOfString:@"="].location : 20;
        fullIDString = equalSignPos < 20 ? [track2 substringWithRange:NSMakeRange(7, equalSignPos-7)] : [track2 substringWithRange:NSMakeRange(7, 13)];
        NSString *overflowIDString = @"";
        // = + 12 chars to last =
        lastEqualSignPos = [track2 rangeOfString:@"=" options:NSBackwardsSearch].location;
        overflowIDString = [track2 substringWithRange:NSMakeRange(equalSignPos + 13, lastEqualSignPos - (equalSignPos + 13)) ];
        fullIDString =[NSString stringWithFormat:@"%@%@",fullIDString, overflowIDString ? overflowIDString : @""];
        ID = fullIDString;
        
        if([State isEqualToString:@"FL"])
        {
            //if the first 2 chars of the id number are numeric
            if([fullIDString substringWithRange:NSMakeRange(0, 2)].intValue)
            {
                ID = [NSString stringWithFormat:@"%c%@",
                      [fullIDString substringWithRange:NSMakeRange(0, 2)].intValue + 64,
                      [fullIDString substringFromIndex:2]];
            }
        }
        
        if([State isEqualToString:@"OH"])
        {
            //if the first 4 chars of the id number are numeric
            if([fullIDString substringWithRange:NSMakeRange(0, 4)].intValue)
            {
               ID = [NSString stringWithFormat:@"%c%c%@",
                      [fullIDString substringWithRange:NSMakeRange(0, 2)].intValue + 64,
                      [fullIDString substringWithRange:NSMakeRange(2, 2)].intValue + 64,
                      [fullIDString substringFromIndex:4]];
            }
        }
        ExpirationDate = [track2 substringWithRange:NSMakeRange(equalSignPos + 1, 4)];
        
        NSString *dateString = [track2 substringWithRange:NSMakeRange(equalSignPos + 5, 8)];
        BirthDate = [[dateString substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"99"] && ![ExpirationDate isEqualToString:@""] ? [NSString stringWithFormat:@"%@%@%@", [dateString substringWithRange:NSMakeRange(0, 4)], [ExpirationDate substringWithRange:NSMakeRange(2, 2)], [dateString substringWithRange:NSMakeRange(6, 2)]] : dateString;
        
        
        if(BirthDate.length > 0)
        {
            switch ([ExpirationDate substringWithRange:NSMakeRange(2, 2)].intValue) {
                case 77:
                    ExpirationDate = @"";
                    break;
                case 88:
                    ExpirationDate = [NSString stringWithFormat:@"20%d%@", [ExpirationDate substringWithRange:NSMakeRange(0, 2)].intValue + 1, [BirthDate substringWithRange:NSMakeRange(4, 4)] ];
                    break;
                case 99:
                    ExpirationDate = [NSString stringWithFormat:@"20%@%@", [ExpirationDate substringWithRange:NSMakeRange(0, 2)], [BirthDate substringWithRange:NSMakeRange(4, 4)] ];
                    break;
                default:
                    ExpirationDate = [NSString stringWithFormat:@"20%@%@", ExpirationDate, [BirthDate substringWithRange:NSMakeRange(6, 2)] ];
                    break;
            }
        }else{
            ExpirationDate = @"";
        }
        
        if(ExpirationDate.length > 0)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd"];

            NSDate *formattedExpDate = [dateFormatter dateFromString:ExpirationDate];
            if(formattedExpDate)
            {
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                ExpirationDate = [dateFormatter stringFromDate:formattedExpDate ];
            }
        }

        if(BirthDate.length > 0)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            
            NSDate *formattedExpDate = [dateFormatter dateFromString:BirthDate];
            if(formattedExpDate)
            {
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                BirthDate = [dateFormatter stringFromDate:formattedExpDate ];
            }
        }
    }
    if(BirthDate.length == 0){BirthDate = nil;}
    if(DateIssued.length == 0){DateIssued = nil;}
    if(ExpirationDate.length == 0){ExpirationDate = nil;}
    
    /************************************************************************************************************
        END TRACK 2
     ************************************************************************************************************/
    
    /************************************************************************************************************
      TRACK 3
     ************************************************************************************************************/
    if(track3)
    {
        Zip = [track3 substringWithRange:NSMakeRange(3, 10)];
        
        NSString *gender =[track3 substringWithRange:NSMakeRange(30, 1)];
        if([gender isEqualToString:@"1"] || [gender isEqualToString:@"M"] || [gender isEqualToString:@"m"]){ Gender = @"M"; }
        if([gender isEqualToString:@"2"] || [gender isEqualToString:@"F"] || [gender isEqualToString:@"m"]){ Gender = @"F"; }
        
        Height = [track3 substringWithRange:NSMakeRange(31, 3)];
        Weight = [track3 substringWithRange:NSMakeRange(34, 3)];
        HairColor = [track3 substringWithRange:NSMakeRange(37, 3)];
        EyeColor = [track3 substringWithRange:NSMakeRange(40, 3)];
    }
    /************************************************************************************************************
     END TRACK 3
     ************************************************************************************************************/
    
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    sharedObjects.scannedLicense = self;
    
    return  @"";
    
}

-(void)decode2DBarcode:(NSString *)barcode;
{
    NSArray *barcodeParts = [barcode componentsSeparatedByString:@"\n"];
    NSString *barcodePart = @"";
    for (barcodePart in barcodeParts)
    {
        if([barcodePart containsString:@"DAQ"])
        {
            ID = [barcodePart substringFromIndex:[barcodePart rangeOfString:@"DAQ"].location + 3];
        }
        
        if([barcodePart containsString:@"DAA"])
        {
            NSArray *nameParts = [[barcodePart substringFromIndex:[barcodePart rangeOfString:@"DAA"].location + 3] componentsSeparatedByString:@","];
            FirstName = nameParts[1];
            LastName = nameParts[0];
        }
        
        if([barcodePart containsString:@"DBA"])
        {
            ExpirationDate = [barcodePart substringFromIndex:[barcodePart rangeOfString:@"DBA"].location + 3];
        }
        
        if([barcodePart containsString:@"DBB"])
        {
            BirthDate = [barcodePart substringFromIndex:[barcodePart rangeOfString:@"DBB"].location + 3];
        }

        if([barcodePart containsString:@"DBC"])
        {
            NSString *gender = [barcodePart substringFromIndex:[barcodePart rangeOfString:@"DBC"].location + 3];
            if([gender isEqualToString:@"1"] || [gender isEqualToString:@"M"] || [gender isEqualToString:@"m"]){ Gender = @"M"; }
            if([gender isEqualToString:@"2"] || [gender isEqualToString:@"F"] || [gender isEqualToString:@"m"]){ Gender = @"F"; }
            
        }
        
        if([barcodePart containsString:@"DAY"])
        {
            EyeColor = [barcodePart substringFromIndex:[barcodePart rangeOfString:@"DAY"].location + 3];
        }
        
        if([barcodePart containsString:@"DAU"])
        {
            Height = [barcodePart substringFromIndex:[barcodePart rangeOfString:@"DAU"].location + 3];
            if(Height.length > 3) { Height = [Height substringWithRange:NSMakeRange(0, 3)]; }
        }
        
        if([barcodePart containsString:@"DAG"])
        {
            Address1 = [barcodePart substringFromIndex:[barcodePart rangeOfString:@"DAG"].location + 3];
        }
        
        if([barcodePart containsString:@"DAI"])
        {
            City = [barcodePart substringFromIndex:[barcodePart rangeOfString:@"DAI"].location + 3];
        }
        
        if([barcodePart containsString:@"DAJ"])
        {
            State = [barcodePart substringFromIndex:[barcodePart rangeOfString:@"DAJ"].location + 3];
        }
        
        if([barcodePart containsString:@"DAK"])
        {
            Zip = [barcodePart substringFromIndex:[barcodePart rangeOfString:@"DAK"].location + 3];
        }
        
        if([barcodePart containsString:@"DBD"])
        {
            DateIssued = [barcodePart substringFromIndex:[barcodePart rangeOfString:@"DBD"].location + 3];
        }
        
        if([barcodePart containsString:@"DAH"])
        {
            Address2 = [barcodePart substringFromIndex:[barcodePart rangeOfString:@"DAH"].location + 3];
        }
        
        if([barcodePart containsString:@"DAZ"])
        {
            HairColor = [barcodePart substringFromIndex:[barcodePart rangeOfString:@"DAZ"].location + 3];
        }
        
        if([barcodePart containsString:@"DCL"])
        {
            Race = [barcodePart substringFromIndex:[barcodePart rangeOfString:@"DCL"].location + 3];
        }
        
        if([barcodePart containsString:@"DCI"])
        {
            BirthPlace = [barcodePart substringFromIndex:[barcodePart rangeOfString:@"DCI"].location + 3];
        }
        
        if([barcodePart containsString:@"DCE"])
        {
            Weight = [barcodePart substringFromIndex:[barcodePart rangeOfString:@"DCE"].location + 3];
        }
    }
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    if([State isEqualToString:@"TX"])
    {
        [dateFormatter setDateFormat:@"MMddyyyy"];
        
    }else{
        [dateFormatter setDateFormat:@"yyyyMMdd"];
    }
    
    NSDate *tmpBDate = [dateFormatter dateFromString:BirthDate];
    NSDate *tmpExpDate = [dateFormatter dateFromString:ExpirationDate];
    NSDate *tmpIssueDate = [dateFormatter dateFromString:DateIssued];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    if(tmpBDate){ BirthDate = [dateFormatter stringFromDate:tmpBDate ]; }
    if(tmpExpDate){ ExpirationDate = [dateFormatter stringFromDate:tmpExpDate ]; }
    if(tmpIssueDate){ DateIssued = [dateFormatter stringFromDate:tmpIssueDate ]; }

    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    sharedObjects.scannedLicense = self;
}

@end
