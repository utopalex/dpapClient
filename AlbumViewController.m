//
//  AlbumViewController.m
//  dpapClient
//
//  Created by Alexander Lehmann on 07.04.13.
//  Copyright (c) 2013 Alexander Lehmann. All rights reserved.
//

#import "AlbumViewController.h"
#import "AppSettings.h"
#import "ItemViewController.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

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
    return self.itemsContainerArray.count;
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
    
    if (indexPath.row < self.itemsContainerArray.count)
    {
        NSArray* currentContainerInfo = self.itemsContainerArray[indexPath.row];
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
    if (indexPath.row < self.itemsContainerArray.count)
    {
        NSArray* currentContainerInfo = self.itemsContainerArray[indexPath.row];
        NSArray* listingItemContainer = [self.dmapSession findAndInterpretValueFor:@"dmap.listingitem" inContainer:currentContainerInfo];
        if (listingItemContainer)
        {
            NSInteger itemId = [[self.dmapSession findAndInterpretValueFor:@"dmap.itemid" inContainer:listingItemContainer] intValue];
            NSLog(@"Album item %i", itemId);
            ItemViewController* itemViewController = [[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
            itemViewController.imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/databases/%i/items?session-id=%i&meta=dpap.hires,dmap.itemid,dpap.filedata&query=('dmap.itemid:%i')",
                                                                           self.dmapSession.hostName,
                                                                           [self.dmapSession.databaseId intValue],
                                                                           [self.dmapSession.sessionId intValue],
                                                                           itemId]];
            NSLog(@"Image URL %@", itemViewController.imageUrl);
            itemViewController.dmapSession = self.dmapSession;
            [self.navigationController pushViewController:itemViewController animated:YES];

        }
    }
}

@end
