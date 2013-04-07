//
//  ItemViewController.m
//  dpapClient
//
//  Created by Alexander Lehmann on 07.04.13.
//  Copyright (c) 2013 Alexander Lehmann. All rights reserved.
//

#import "ItemViewController.h"
#import "AFNetworking.h"
#import "AppSettings.h"
#import "DMAPDecoder.h"

@interface ItemViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) AFHTTPClient* client;

@end

@implementation ItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableURLRequest *request = [AppSettings buildRequest:self.imageUrl authorize:YES];
    if (!_client)
    {
        self.client = [AFHTTPClient clientWithBaseURL:self.imageUrl];
    }
    AFHTTPRequestOperation* httpRequestOperation = [self.client HTTPRequestOperationWithRequest:request
                                                                                        success:^(AFHTTPRequestOperation *operation, id responseObject)
                                                    {
                                                        DMAPDecoder* dmapDecoder = [[DMAPDecoder alloc] init];
                                                        NSArray* array = [dmapDecoder parseDmapResponse:responseObject];
                                                        NSData* data = [self.dmapSession findAndInterpretValueFor:@"dpap.picturedata" inContainer:array];
                                                        if (data && [data isKindOfClass:[NSData class]])
                                                        {
                                                            UIImage* image = [UIImage imageWithData:data];
                                                            [self.imageView setImage:image];
                                                        }
                                                         
                                                        
                                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                        NSLog(@"Failure during retrieving item info %@",error);
                                                    }];
    [httpRequestOperation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [super viewDidUnload];
}
@end
