//
//  MyListViewController.m
//  Allayer
//
//  Created by Vadim Molchanov on 2/18/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import "MyListViewController.h"
#import "ServerManager.h"

@implementation MyListViewController

static NSInteger songsInRequest = 50;

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getFromServer {
    [self getMyListFromServer];
}


#pragma mark - API

- (void)refreshSongs {
    
    [[ServerManager sharedManager] getMyListWithOffset:0
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


- (void)getMyListFromServer {
    
    [[ServerManager sharedManager] getMyListWithOffset:[self.songsArray count]
                                                 count:songsInRequest
                                             onSuccess:^(NSArray *songs) {
                                                 [self.songsArray addObjectsFromArray:songs];
                                                 [self.tableView reloadData];
                                             }
                                             onFailure:^(NSError *error, NSInteger statusCode) {
                                                 NSLog(@"Error = %@, Code = %ld", [error localizedDescription], (long)statusCode);
                                             }];
    
}


#pragma mark - Actions

- (IBAction)playQueueAction:(UIButton *)sender {
    NSLog(@"Play");
    Song *song = [self.songsArray objectAtIndex:sender.tag];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:song.artist
                                                                             message:song.title
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *playNext = [UIAlertAction
                               actionWithTitle:@"Play Next"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   
                                   [[PlayQueueManager sharedManager] queueNext:song];
                               }];
    
    
    UIAlertAction *playLast = [UIAlertAction
                               actionWithTitle:@"Play Last"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   
                                   [[PlayQueueManager sharedManager] queueLast:song];
                               }];
    
    UIAlertAction *showSimilar = [UIAlertAction
                                  actionWithTitle:@"Show Similar"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action) {
                                      
                                      NSString *target = [NSString stringWithFormat:@"%ld_%ld", (long)song.ownerID, (long)song.ID];
                                      [[ServerManager sharedManager] getRecommendedWithTarget:target
                                                                                       offset:0
                                                                                        count:songsInRequest
                                                                                    onSuccess:^(NSArray *songs) {
                                                                                        
                                                                                        [self.songsArray removeAllObjects];
                                                                                        [self.songsArray addObjectsFromArray:songs];
                                                                                        [self.tableView reloadData];
                                                                                        
                                                                                    }
                                                                                    onFailure:^(NSError *error, NSInteger statusCode) {
                                                                                        
                                                                                        NSLog(@"Error = %@, Code = %ld", [error localizedDescription], (long)statusCode);
                                                                                    }];
                                  }];
    
    UIAlertAction *deleteFromMyList = [UIAlertAction
                                  actionWithTitle:@"Delete From My List"
                                  style:UIAlertActionStyleDestructive
                                  handler:^(UIAlertAction *action) {
                                      
                                      [[ServerManager sharedManager] getAudioDeletedWithID:song.ID
                                                                                     owner:song.ownerID
                                                                                 onSuccess:^(bool result) {
                                                                                     
                                                                                     NSLog(@"New Song ID: %d", result);
                                                                                 }
                                                                                 onFailure:^(NSError *error, NSInteger statusCode) {
                                                                                     
                                                                                     NSLog(@"Error = %@, Code = %ld", [error localizedDescription], (long)statusCode);
                                                                                 }];
                                      
                                      [self.songsArray removeObjectAtIndex:sender.tag];
                                      [self.tableView reloadData];
                                      
                                  }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action) {
                                       
                                       NSLog(@"Cancel action");
                                   }];
    
    [alertController addAction:playNext];
    [alertController addAction:playLast];
    [alertController addAction:showSimilar];
    [alertController addAction:deleteFromMyList];
    [alertController addAction:cancelAction];
    
    alertController.view.tintColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.5 alpha:1.0];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}




@end
