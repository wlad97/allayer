//
//  ServerManager.h
//  Allayer
//
//  Created by Vadim Molchanov on 2/5/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface ServerManager : NSObject

@property (strong, nonatomic, readonly) User *currentUser;

+ (ServerManager *)sharedManager;

- (void)authorizeUser:(void(^)(User *user))completion;

- (void)getUser:(NSString *)userID
      onSuccess:(void(^)(User *user))success
      onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getPopularWithGenre:(NSInteger)genre
                     offset:(NSInteger)offset
                      count:(NSInteger)count
                    english:(BOOL)english
                  onSuccess:(void(^)(NSArray *songs))success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getRecommendedWithTarget:(NSString *)target
                          offset:(NSInteger)offset
                           count:(NSInteger)count
                       onSuccess:(void(^)(NSArray *songs))success
                       onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getMyListWithOffset:(NSInteger)offset
                           count:(NSInteger)count
                       onSuccess:(void(^)(NSArray *songs))success
                       onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getSearchResults:(NSString*)query
              withOffset:(NSInteger)offset
                   count:(NSInteger)count
               onSuccess:(void(^)(NSArray *songs))success
               onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getAudioAddedWithID:(NSInteger)audio
                      owner:(NSInteger)owner
                  onSuccess:(void(^)(NSInteger newSongID))success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getAudioDeletedWithID:(NSInteger)audio
                        owner:(NSInteger)owner
                    onSuccess:(void(^)(bool result))success
                    onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;


@end
