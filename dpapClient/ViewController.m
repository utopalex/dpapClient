//
//  ViewController.m
//  dpapClient
//
//  Created by Alexander Lehmann on 17.11.12.
//  Copyright (c) 2012 Alexander Lehmann. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "DMAPDecoder.h"
#import "DMAPSession.h"
#import "AppSettings.h"
#import "ContainerViewController.h"
#include <arpa/inet.h>

@interface ViewController ()

@property(nonatomic, strong) DMAPDecoder* decoder;
@property(nonatomic, strong) DMAPSession* session;
@property(nonatomic, strong) AFHTTPClient* client;
@property (weak, nonatomic) IBOutlet UITextField *hostNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property(nonatomic, strong) NSNetServiceBrowser *serviceBrowser;
@property (nonatomic, strong) NSMutableArray *services;
@end

@implementation ViewController

BOOL searching;

-(DMAPDecoder*) decoder
{
    if (!_decoder)
    {
        _decoder = [[DMAPDecoder alloc] init];
    }
    return _decoder;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hostNameTextField.text  = @"127.0.0.1:8770";
        
    self.serviceBrowser = [[NSNetServiceBrowser alloc] init];
    [self.serviceBrowser setDelegate:self];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.serviceBrowser searchForServicesOfType:@"_dpap._tcp." inDomain:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) queryContainers
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/databases/%i/containers?session-id=%i",
                                       self.session.hostName,
                                       [self.session.databaseId intValue],
                                       [self.session.sessionId intValue]]];
    NSMutableURLRequest *request = [AppSettings buildRequest:url authorize:YES];
    AFHTTPRequestOperation* httpRequestOperation = [self.client HTTPRequestOperationWithRequest:request
                                                                                        success:^(AFHTTPRequestOperation *operation, id responseObject)
                                                    {
                                                        NSArray* array = [self.decoder parseDmapResponse:responseObject];
                                                        int returnedCount = [[self.session findAndInterpretValueFor:@"dmap.returnedcount" inContainer:array] intValue];
                                                        NSArray* listing = [self.session findAndInterpretValueFor:@"dmap.listing" inContainer:array];
                                                        NSLog(@"Expecting %i containers - got %i", returnedCount, listing.count);
                                                        self.session.containers = listing;
                                                        ContainerViewController* containerViewController = [[ContainerViewController alloc] initWithStyle:UITableViewStylePlain];
                                                        containerViewController.dmapSession = self.session;
                                                        [self.navigationController pushViewController:containerViewController animated:YES];
                                                        
                                                        
                                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                        NSLog(@"Failure during retrieving containers %@",error);
                                                    }];
    [httpRequestOperation start];
}

-(void) queryDatabases
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/databases?session-id=%i",
                                       self.session.hostName,
                                       [self.session.sessionId intValue]]];
    NSMutableURLRequest *request = [AppSettings buildRequest:url authorize:YES];
    AFHTTPRequestOperation* httpRequestOperation = [self.client HTTPRequestOperationWithRequest:request
                                                                                        success:^(AFHTTPRequestOperation *operation, id responseObject)
                                                    {
                                                        [self.session setDatabasesInfo:[self.decoder parseDmapResponse:responseObject]];
                                                        if (self.session.databaseId)
                                                        {
                                                            [self queryContainers];
                                                        }
                                                        
                                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                        NSLog(@"Failure during retrieving databases %@",error);
                                                    }];
    [httpRequestOperation start];
}

-(void) login
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/login",
                                       self.session.hostName]];
    NSMutableURLRequest *request = [AppSettings buildRequest:url authorize:YES];
    AFHTTPRequestOperation* httpRequestOperation = [self.client HTTPRequestOperationWithRequest:request
                                                                                        success:^(AFHTTPRequestOperation *operation, id responseObject)
                                                    {
                                                        [self.session setLoginInfo:[self.decoder parseDmapResponse:responseObject]];
                                                        if (self.session.sessionId)
                                                        {
                                                            [self queryDatabases];
                                                        }
                                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                        NSLog(@"Failure during login %@",error);
                                                        
                                                    }];
    [httpRequestOperation start];
}
- (IBAction)didPressConnectiPsf:(id)sender {
    [self didPressConnect:sender];
}

- (IBAction)didPressConnect:(id)sender {
    NSString* hostName = self.hostNameTextField.text;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/server-info",
                                       hostName]];
    NSMutableURLRequest *request = [AppSettings buildRequest:url authorize:NO];
    self.client = [AFHTTPClient clientWithBaseURL:url];
    AFHTTPRequestOperation* httpRequestOperation = [self.client HTTPRequestOperationWithRequest:request
                                                                                        success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        self.session = [[DMAPSession alloc] init];
        self.session.hostName = hostName;
        [self.session setServerInfo:[self.decoder parseDmapResponse:responseObject]];
        [self login];
    }
                                                                                        failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        
    }];
    [httpRequestOperation start];
}

#pragma mark helper

- (void)viewDidUnload {
    [self setHostNameTextField:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
}

#pragma mark NSNetServiceBrowserDelegate

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
           didFindService:(NSNetService *)aNetService
               moreComing:(BOOL)moreComing
{
    if (!self.services) {
        self.services = [[NSMutableArray alloc] init];
    }
    [self.services addObject:aNetService];
    [aNetService setDelegate:self];
    [aNetService resolveWithTimeout:3.0];
    if(!moreComing)
    {
       [browser stop];
    }
}

#pragma mark NSNetServiceDelegate

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
    for (NSData* data in [sender addresses]) {
        char addressBuffer[100];
        struct sockaddr_in* socketAddress = (struct sockaddr_in*) [data bytes];
        int sockFamily = socketAddress->sin_family;
        if (sockFamily == AF_INET || sockFamily == AF_INET6) {
            const char* addressStr = inet_ntop(sockFamily,
                                               &(socketAddress->sin_addr), addressBuffer,
                                               sizeof(addressBuffer));
            int port = ntohs(socketAddress->sin_port);
            if (addressStr && port)
            {
                NSLog(@"Found service at %s:%d", addressStr, port);
                self.hostNameTextField.text  = [NSString stringWithFormat:@"%s:%d", addressStr, port];
                break;
            }
        }
    }
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
    NSLog(@"Error resolving: %@", errorDict );
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.serviceBrowser stop];
    for (NSNetService* service in self.services) {
        [service stop];
    }
    [self.services removeAllObjects];
}

@end
