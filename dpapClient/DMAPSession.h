//
//  DMAPSession.h
//  dpapClient
//
//  Created by Alexander Lehmann on 19.11.12.
//  Copyright (c) 2012 Alexander Lehmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMAPSession : NSObject

@property(nonatomic, readonly) NSNumber* sessionId;
@property(nonatomic, readonly) NSNumber* databaseId;
@property(nonatomic, strong) NSArray* containers;
@property(nonatomic, strong) NSString* hostName;

-(void) setServerInfo:(NSArray*) serverResponse;
-(void) setLoginInfo:(NSArray*) serverResponse;
-(void) setDatabasesInfo:(NSArray*) serverResponse;
-(id) findAndInterpretValueFor:(NSString*) key inContainer:(NSArray*) container;

@end


