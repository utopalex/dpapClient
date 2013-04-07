//
//  ContainerViewController.h
//  dpapClient
//
//  Created by Alexander Lehmann on 18.03.13.
//  Copyright (c) 2013 Alexander Lehmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMAPSession.h"

@interface ContainerViewController : UITableViewController

@property(nonatomic, strong) DMAPSession* dmapSession;

@end
