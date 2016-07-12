//
//  ServerManager.m
//  Allayer
//
//  Created by Vadim Molchanov on 2/5/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking/AFNetworking.h"
#import "User.h"
#import "LoginViewController.h"
#import "AccessToken.h"
#import "Song.h"

@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) AccessToken *accessToken;

@end

@implementation ServerManager

+ (ServerManager *)sharedManager {
    
    static ServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        NSURL *baseURL = [NSURL URLWithString:@"https://api.vk.com/method/"];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    }
    return self;
}


- (void)authorizeUser:(void(^)(User *user))completion {
    
    LoginViewController *loginVC = [[LoginViewController alloc] initWithCompletionBlock:^(AccessToken *token) {
        self.accessToken = token;
        
        if (token) {
            
            [self getUser:self.accessToken.userID
                onSuccess:^(User *user) {
                    if (completion) {
                        completion(user);
                    }
                }
                onFailure:^(NSError *error, NSInteger statusCode) {
                    if (completion) {
                        completion(nil);
                    }
                }];
            
        } else if (completion) {
            completion(nil);
        }
    }];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    UIViewController *mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    [mainVC presentViewController:navController animated:YES completion:nil];
    
//    NSLog(@"%@", self.accessToken);
    
}


- (void)getPopularWithGenre:(NSInteger)genre
                     offset:(NSInteger)offset
                      count:(NSInteger)count
                    english:(BOOL)english
                  onSuccess:(void(^)(NSArray *songs))success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(genre),               @"genre_id",
                            @(count),               @"count",
                            @(offset),              @"offset",
                            @(english),             @"only_eng",
                            @"5.44",                @"v",
                            self.accessToken.token, @"access_token", nil];
    
    [self.sessionManager GET:@"audio.getPopular"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionTask *task, NSDictionary *responseObject) {

                         NSArray *dictsArray = [responseObject objectForKey:@"response"];
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary *iDict in dictsArray) {
                             Song *song = [[Song alloc] initWithServerResponse:iDict];
                             [objectsArray addObject:song];
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }
                     }
                     failure:^(NSURLSessionTask *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         if (failure) {
                             failure(error, [(NSHTTPURLResponse *)operation.response statusCode]);
                         }
                         
                     }];
}

- (void)getRecommendedWithTarget:(NSString *)target
                          offset:(NSInteger)offset
                           count:(NSInteger)count
                       onSuccess:(void(^)(NSArray *songs))success
                       onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            target,                 @"target_audio",
                            @(count),               @"count",
                            @(offset),              @"offset",
                            @"1",                   @"shuffle",
                            @"5.44",                @"v",
                            self.accessToken.token, @"access_token", nil];
    
    [self.sessionManager GET:@"audio.getRecommendations"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionTask *task, NSDictionary *responseObject) {
                         
                         responseObject = [responseObject objectForKey:@"response"];
                         NSArray *dictsArray = [responseObject objectForKey:@"items"];
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary *iDict in dictsArray) {
                             Song *song = [[Song alloc] initWithServerResponse:iDict];
                             [objectsArray addObject:song];
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }
                     }
                     failure:^(NSURLSessionTask *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         if (failure) {
                             failure(error, [(NSHTTPURLResponse *)operation.response statusCode]);
                         }
                         
                     }];
}

- (void)getMyListWithOffset:(NSInteger)offset
                           count:(NSInteger)count
                       onSuccess:(void(^)(NSArray *songs))success
                       onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(count),               @"count",
                            @(offset),              @"offset",
                            @"0",                   @"need_user",
                            @"5.45",                @"v",
                            self.accessToken.token, @"access_token", nil];
    
    [self.sessionManager GET:@"audio.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionTask *task, NSDictionary *responseObject) {
                         
                         responseObject = [responseObject objectForKey:@"response"];
                         NSArray *dictsArray = [responseObject objectForKey:@"items"];
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary *iDict in dictsArray) {
                             Song *song = [[Song alloc] initWithServerResponse:iDict];
                             [objectsArray addObject:song];
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }
                     }
                     failure:^(NSURLSessionTask *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         if (failure) {
                             failure(error, [(NSHTTPURLResponse *)operation.response statusCode]);
                         }
                         
                     }];
}

- (void)getSearchResults:(NSString*)query
              withOffset:(NSInteger)offset
                   count:(NSInteger)count
               onSuccess:(void(^)(NSArray *songs))success
               onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            query,                  @"q",
                            @"2",                   @"sort",
                            @(count),               @"count",
                            @(offset),              @"offset",
                            @"5.44",                @"v",
                            self.accessToken.token, @"access_token", nil];
    
    [self.sessionManager GET:@"audio.search"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionTask *task, NSDictionary *responseObject) {
                         
                         responseObject = [responseObject objectForKey:@"response"];
                         NSArray *dictsArray = [responseObject objectForKey:@"items"];
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary *iDict in dictsArray) {
                             Song *song = [[Song alloc] initWithServerResponse:iDict];
                             [objectsArray addObject:song];
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }
                     }
                     failure:^(NSURLSessionTask *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         if (failure) {
                             failure(error, [(NSHTTPURLResponse *)operation.response statusCode]);
                         }
                         
                     }];
}

- (void)getAudioAddedWithID:(NSInteger)audio
                      owner:(NSInteger)owner
                  onSuccess:(void(^)(NSInteger newSongID))success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(audio),               @"audio_id",
                            @(owner),               @"owner_id",
                            @"5.45",                @"v",
                            self.accessToken.token, @"access_token", nil];
    
    [self.sessionManager GET:@"audio.add"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionTask *task, NSDictionary *responseObject) {
                         
                         NSInteger songID = [[responseObject objectForKey:@"response"] integerValue];
                         
                         if (success) {
                             success(songID);
                         }
                     }
                     failure:^(NSURLSessionTask *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         if (failure) {
                             failure(error, [(NSHTTPURLResponse *)operation.response statusCode]);
                         }
                     }];
}

- (void)getAudioDeletedWithID:(NSInteger)audio
                        owner:(NSInteger)owner
                    onSuccess:(void(^)(bool result))success
                    onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(audio),               @"audio_id",
                            @(owner),               @"owner_id",
                            @"5.45",                @"v",
                            self.accessToken.token, @"access_token", nil];
    
    [self.sessionManager GET:@"audio.delete"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionTask *task, NSDictionary *responseObject) {
                         
                         bool result  = [[responseObject objectForKey:@"response"] boolValue];
                         
                         if (success) {
                             success(result);
                         }
                     }
                     failure:^(NSURLSessionTask *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         if (failure) {
                             failure(error, [(NSHTTPURLResponse *)operation.response statusCode]);
                         }
                     }];
}


//5244235 - appID, 305779150 - vkID

- (void)getUser:(NSString *)userID
      onSuccess:(void(^)(User *user))success
      onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userID,         @"user_ids",
                            @"nom",         @"name_case", nil];
    
    [self.sessionManager GET:@"users.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionTask *task, NSDictionary *responseObject) {
//                         NSLog(@"Get User: %@", responseObject);
                         
                         NSArray *dictsArray = [responseObject objectForKey:@"response"];
                         
                         if ([dictsArray count] > 0) {
                             
                             User *user = [[User alloc] initWithServerResponse:[dictsArray firstObject]];
                             if (success) {
                                 success(user);
                             }
                         } else {
                             if (failure) {
                                 failure(nil, [(NSHTTPURLResponse *)task.response statusCode]);
                             }
                             
                         }
                     }
                     failure:^(NSURLSessionTask *task, NSError *error) {
                         NSLog(@"Error: %@", error);
                         if (failure) {
                             failure(error, [(NSHTTPURLResponse *)task.response statusCode]);
                         }
                     }];
}


@end
