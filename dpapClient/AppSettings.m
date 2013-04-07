//
//  AppSettings.m
//  dpapClient
//
//  Created by Alexander Lehmann on 07.04.13.
//  Copyright (c) 2013 Alexander Lehmann. All rights reserved.
//

#import "AppSettings.h"

@implementation AppSettings

+ (NSMutableURLRequest *)buildRequest:(NSURL *)url authorize:(BOOL) authorize {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"1.1" forHTTPHeaderField:@"Client-DPAP-Version"];
    [request setValue:@"iPhoto/9.2.1  (Macintosh; N; PPC)" forHTTPHeaderField:@"User-Agent"];
    if (authorize)
    {
        [request setValue:@"Basic YWRyaWFuYTpuZXRzY2FwZQ==" forHTTPHeaderField:@"Authorization"];
    }
    return request;
}

@end
