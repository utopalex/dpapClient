//
//  DMAPSession.m
//  dpapClient
//
//  Created by Alexander Lehmann on 19.11.12.
//  Copyright (c) 2012 Alexander Lehmann. All rights reserved.
//

#import "DMAPSession.h"

@implementation DMAPSession

-(void) setServerInfo:(NSArray*) serverResponse
{
    
}

-(id) findAndInterpretValueFor:(NSString*) key inContainer:(NSArray*) container
{
    id resultValue = NULL;
    NSDictionary* relevantDict = NULL;
    BOOL interpretItLater = NO;
    if ([container isKindOfClass:[NSDictionary class]])
    {
        container = @[container];
    }
    for (NSDictionary* dict in container)
    {
        if ([[dict objectForKey:@"NAME"] isEqual:key])
        {
            relevantDict = dict;
            interpretItLater = YES;
        }
        else if ([[dict objectForKey:@"TYPE"] isEqual:@"Container"])
        {
            relevantDict = [self findAndInterpretValueFor:key inContainer:[dict objectForKey:@"DATA"]];
        }
        if (relevantDict)
            break;
    }
    if (relevantDict && interpretItLater && [relevantDict isKindOfClass:[NSDictionary class]] )
    {
        if ([[relevantDict objectForKey:@"TYPE"] isEqual:@"integer"])
        {
            NSData* dictData = [relevantDict objectForKey:@"DATA"];
            NSInteger integerValue;
            [dictData getBytes:&integerValue length:sizeof(NSInteger)];
            NSInteger intValueBE = CFSwapInt32HostToBig(integerValue);
            NSNumber* number = [NSNumber numberWithInteger:intValueBE];
            resultValue = number;
        }
        if ([[relevantDict objectForKey:@"TYPE"] isEqual:@"string"])
        {
            NSData* dictData = [relevantDict objectForKey:@"DATA"];
            NSString* value = [[NSString alloc] initWithData:dictData encoding:NSUTF8StringEncoding];
            resultValue = value;
        }
        else if ([[relevantDict objectForKey:@"TYPE"] isEqual:@"Container"])
        {
            resultValue = [relevantDict objectForKey:@"DATA"];
        }
    }
    else
        resultValue = relevantDict;
    return resultValue;
}

-(void) setLoginInfo:(NSArray*) serverResponse
{
    if (serverResponse.count == 1)
    {
        _sessionId = [self findAndInterpretValueFor:@"dmap.sessionid" inContainer:serverResponse];
    }
}

-(void) setDatabasesInfo:(NSArray*) serverResponse
{
    if (serverResponse.count == 1)
    {
        NSNumber* returnCount = [self findAndInterpretValueFor:@"dmap.returnedcount" inContainer:serverResponse];
        if ([returnCount intValue] > 0)
        {
           _databaseId = [self findAndInterpretValueFor:@"dmap.returnedcount" inContainer:serverResponse];
            
        }
        
    }
}


@end
