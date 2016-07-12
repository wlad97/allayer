//
//  PlayListViewController.m
//  Allayer
//
//  Created by Vadim Molchanov on 2/22/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import "PlayListViewController.h"
#import "ServerManager.h"

@interface PlayListViewController ()

@end

@implementation PlayListViewController

static NSInteger songsInRequest = 50;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1.0 green:0.0 blue:0.5 alpha:1.0]}];
    
    self.songsArray = [NSMutableArray array];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshSongs) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;

/*    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem; */
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getFromServer];
//    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshSongs {
}

- (void)getFromServer {
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.songsArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.songsArray count]) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MoreCell"];
        }
        
        cell.textLabel.text = @"Show More Songs";
        cell.backgroundColor = [UIColor colorWithRed:0 green:50 blue:100 alpha:0.2];
        return cell;
        
    } else {
        
        SongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SongCell"];
        cell.index = indexPath.row;

        Song *song = [self.songsArray objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor colorWithRed:254 / 255.0 green:252 / 255.0 blue:255 / 255.0 alpha:1.0];
        cell.artistLabel.text = [NSString stringWithFormat:@"%@", song.artist];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@", song.title];
        
        NSInteger seconds = song.duration % 60;
        NSInteger minutes = (song.duration / 60) % 60;
        cell.durationLabel.text = [NSString stringWithFormat:@"%ld:%02ld", (long)minutes, (long)seconds];

        return cell;
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.songsArray count]) {
        [self getFromServer];
        
    } else {

        Song *song = [self.songsArray objectAtIndex:indexPath.row];
        [[PlayQueueManager sharedManager] playNow:song];

    }
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

    UIAlertAction *addToMyList = [UIAlertAction
                                  actionWithTitle:@"Add to My List"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action) {

                                      [[ServerManager sharedManager] getAudioAddedWithID:song.ID
                                                                                   owner:song.ownerID
                                                                               onSuccess:^(NSInteger newSongID) {
                                                                               }
                                       
                                                                               onFailure:^(NSError *error, NSInteger statusCode) {
                                                                                   NSLog(@"Error = %@, Code = %ld", [error localizedDescription], (long)statusCode);
                                                                               }];
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
    [alertController addAction:addToMyList];
    [alertController addAction:cancelAction];
    
    alertController.view.tintColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.5 alpha:1.0];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}


@end
