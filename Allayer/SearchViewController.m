//
//  SearchViewController.m
//  Allayer
//
//  Created by Vadim Molchanov on 2/5/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import "SearchViewController.h"
#import "ServerManager.h"
#import "User.h"

@interface SearchViewController ()

@property (strong, nonatomic) NSString *oldText;
@property (assign, nonatomic) BOOL firstTimeAppear;

@end

@implementation SearchViewController

static NSInteger songsInRequest = 50;

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.songSearchBar.text = [userDefaults objectForKey:@"default_search"];

    self.firstTimeAppear = YES;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.firstTimeAppear) {
        self.firstTimeAppear = NO;
        [[ServerManager sharedManager] authorizeUser:^(User *user) {
//            NSLog(@"Authorized %@ %@", user.firstName, user.lastName);
        }];
    }
    [self getFromServer];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)getFromServer {
    [self getSearchResultsFromServer:self.songSearchBar.text];
}


#pragma mark - API

- (void)refreshSongs {
    
    [[ServerManager sharedManager] getSearchResults:self.songSearchBar.text
                                         withOffset:0
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


- (void)getSearchResultsFromServer:(NSString *)query {
    
    [[ServerManager sharedManager] getSearchResults:query
                                         withOffset:[self.songsArray count]
                                              count:songsInRequest
                                          onSuccess:^(NSArray *songs) {
                                              
                                              [self.songsArray addObjectsFromArray:songs];
                                              [self.tableView reloadData];
                                          }
                                          onFailure:^(NSError *error, NSInteger statusCode) {
                                              NSLog(@"Error = %@, Code = %ld", [error localizedDescription], (long)statusCode);
                                          }];
    
}


#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    searchBar.text = self.oldText;
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];

    self.oldText = searchBar.text;
    [self.songsArray removeAllObjects];

    [self getSearchResultsFromServer:searchBar.text];
    [self.tableView reloadData];

}


@end
