//
//  AlbumViewController.h
//  dpapClient
//
//  Created by Alexander Lehmann on 07.04.13.
//  Copyright (c) 2013 Alexander Lehmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMAPSession.h"

@interface AlbumViewController : UITableViewController

@property(nonatomic, strong) DMAPSession* dmapSession;
@property(nonatomic, strong) NSArray* itemsContainerArray;

@end
