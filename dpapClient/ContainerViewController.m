//
//  ContainerViewController.m
//  dpapClient
//
//  Created by Alexander Lehmann on 18.03.13.
//  Copyright (c) 2013 Alexander Lehmann. All rights reserved.
//

#import "ContainerViewController.h"
#import "AFNetworking.h"
#import "AppSettings.h"
#import "DMAPDecoder.h"
#import "AlbumViewController.h"

@interface ContainerViewController ()

@property(nonatomic, strong) AFHTTPClient* client;
@property(nonatomic, strong) DMAPDecoder* decoder;

@end

@implementation ContainerViewController

-(DMAPDecoder*) decoder
{
    if (!_decoder)
    {
        _decoder = [[DMAPDecoder alloc] init];
    }
    return _decoder;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dmapSession.containers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row < self.dmapSession.containers.count)
    {
        NSArray* currentContainerInfo = self.dmapSession.containers[indexPath.row];
        NSArray* listingItemContainer = [self.dmapSession findAndInterpretValueFor:@"dmap.listingitem" inContainer:currentContainerInfo];
        if (listingItemContainer)
        {
            NSString* title = [self.dmapSession findAndInterpretValueFor:@"dmap.itemname" inContainer:listingItemContainer];
            cell.textLabel.text = title;
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dmapSession.containers.count)
    {
        NSArray* currentContainerInfo = self.dmapSession.containers[indexPath.row];
        NSArray* listingItemContainer = [self.dmapSession findAndInterpretValueFor:@"dmap.listingitem" inContainer:currentContainerInfo];
        if (listingItemContainer)
        {
            NSInteger itemId = [[self.dmapSession findAndInterpretValueFor:@"dmap.itemid" inContainer:listingItemContainer] intValue];
            NSLog(@"Querying for container %i", itemId);
            [self getItemsForContainerId:itemId];
        }
    }
}

#pragma mark Helpers

-(void) getItemsForContainerId:(NSInteger) containerId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/databases/%i/containers/%i/items?session-id=%i&meta=dpap.aspectratio,dmap.itemid,dmap.itemname,dpap.imagefilename,dpap.imagefilesize,dpap.creationdate,dpap.imagepixelwidth,dpap.imagepixelheight,dpap.imageformat,dpap.imagerating,dpap.imagecomments,dpap.imagelargefilesize&type=photo",
                                       self.dmapSession.hostName,
                                       [self.dmapSession.databaseId intValue],
                                       containerId,
                                       [self.dmapSession.sessionId intValue]]];
    NSMutableURLRequest *request = [AppSettings buildRequest:url authorize:YES];
    if (!_client)
    {
        self.client = [AFHTTPClient clientWithBaseURL:url];
    }
    AFHTTPRequestOperation* httpRequestOperation = [self.client HTTPRequestOperationWithRequest:request
                                                                                        success:^(AFHTTPRequestOperation *operation, id responseObject)
                                                    {
                                                        
                                                        NSArray* array = [self.decoder parseDmapResponse:responseObject];
                                                        int returnedCount = [[self.dmapSession findAndInterpretValueFor:@"dmap.returnedcount" inContainer:array] intValue];
                                                        NSArray* listing = [self.dmapSession findAndInterpretValueFor:@"dmap.listing" inContainer:array];
                                                        NSLog(@"Returned %i item - list length is supposed to be %i", listing.count, returnedCount);
                                                        
                                                        AlbumViewController* albumViewController = [[AlbumViewController alloc] initWithStyle:UITableViewStylePlain];
                                                        albumViewController.dmapSession = self.dmapSession;
                                                        albumViewController.itemsContainerArray = listing;
                                                        [self.navigationController pushViewController:albumViewController animated:YES];
                                                        
                                                        
                                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                        NSLog(@"Failure during retrieving item info %@",error);
                                                    }];
    [httpRequestOperation start];

}

@end
