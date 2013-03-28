//
//  LoginRemote.h
//  RubyChina
//
//  Created by dave on 3/21/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface RemoteEngine : MKNetworkEngine

-(MKNetworkOperation*) login:(NSString *)username password:(NSString *)password;

-(MKNetworkOperation*) createTopic:(NSString *)title body:(NSString *)body node_id:(NSNumber *)node_id  ;

-(MKNetworkOperation*) topics:(NSNumber *)page;

-(MKNetworkOperation*) userTopics:(NSNumber *)page login:(NSString *)login;

-(MKNetworkOperation*) topic:(NSNumber *)topicId;

-(MKNetworkOperation*) createReply:(NSNumber *)topicId body:(NSString *)body  ;

-(MKNetworkOperation*) nodes;

-(MKNetworkOperation*) node:(NSNumber *)nodeId;

-(MKNetworkOperation*) user:(NSString *)username;

@end
