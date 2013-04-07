//
//  DMAPDecoder.h
//  dpapClient
//
//  Created by Alexander Lehmann on 18.11.12.
//  Copyright (c) 2012 Alexander Lehmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMAPDecoder : NSObject

-(id) parseDmapResponse:(NSData*) data;

@end

NSDictionary* decodingInfo;