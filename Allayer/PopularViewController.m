//
//  PopularViewController.m
//  Allayer
//
//  Created by Vadim Molchanov on 2/5/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import "PopularViewController.h"
#import "ServerManager.h"

@interface PopularViewController ()

@property (assign, nonatomic) NSInteger genreID;

@end

@implementation PopularViewController

static NSInteger songsInRequest = 50;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.genreID = [userDefaults integerForKey:@"popular_genre"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getFromServer {
    [self getPopularFromServer];
}


#pragma mark - API

- (void)refreshSongs {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [[ServerManager sharedManager] getPopularWithGenre:[userDefaults integerForKey:@"popular_genre"]
                                                offset:0
                                                 count:MAX(songsInRequest, [self.songsArray count])
                                               english:[userDefaults boolForKey:@"english_only"]
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


- (void)getPopularFromServer {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [[ServerManager sharedManager] getPopularWithGenre:[userDefaults integerForKey:@"popular_genre"]
                                                offset:[self.songsArray count]
                                                 count:songsInRequest
                                               english:[userDefaults boolForKey:@"english_only"]
                                             onSuccess:^(NSArray *songs) {
                                                 [self.songsArray addObjectsFromArray:songs];
                                                 [self.tableView reloadData];
                                             }
                                             onFailure:^(NSError *error, NSInteger statusCode) {
                                                 NSLog(@"Error = %@, Code = %ld", [error localizedDescription], (long)statusCode);
                                             }];
    
}


@end
