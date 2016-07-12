//
//  ForYouViewController.m
//  Allayer
//
//  Created by Vadim Molchanov on 2/5/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import "ForYouViewController.h"
#import "ServerManager.h"

@implementation ForYouViewController

static NSInteger songsInRequest = 50;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getFromServer {
    [self getRecommendedTargetFromServer:@""];
}


#pragma mark - API

- (void)refreshSongs {
    
    [[ServerManager sharedManager] getRecommendedWithTarget:@""
                                                     offset:0
                                                      count:MAX(songsInRequest, [self.songsArray count])
                                                  onSuccess:^(NSArray *songs) {
                                                  
                                                      [self.songsArray removeAllObjects];
                                                      [self.songsArray addObjectsFromArray:songs];
                                                      [self.tableView reloadData];
                                                      [self.refreshControl endRefreshing];
                                                  
                                                  }
                                                  onFailure:^(NSError *error, NSInteger statusCode) {
                                                  
                                                      NSLog(@"Error = %@, Code = %ld", [error localizedDescription], (long)statusCode);
                                                      [self.refreshControl endRefreshing];
                                                  
                                                  }];
}


- (void)getRecommendedTargetFromServer:(NSString *)target {
    
    [[ServerManager sharedManager] getRecommendedWithTarget:target
                                                     offset:[self.songsArray count]
                                                      count:songsInRequest
                                                  onSuccess:^(NSArray *songs) {
                                                      [self.songsArray addObjectsFromArray:songs];
                                                      [self.tableView reloadData];
                                                  }
                                                  onFailure:^(NSError *error, NSInteger statusCode) {
                                                      NSLog(@"Error = %@, Code = %ld", [error localizedDescription], (long)statusCode);
                                                  }];
    
}



@end
