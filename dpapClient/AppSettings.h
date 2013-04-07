//
//  AppSettings.h
//  dpapClient
//
//  Created by Alexander Lehmann on 07.04.13.
//  Copyright (c) 2013 Alexander Lehmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject

+ (NSMutableURLRequest *)buildRequest:(NSURL *)url authorize:(BOOL) authorize;

@end





