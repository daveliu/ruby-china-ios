//
//  LoginRemote.m
//  RubyChina
//
//  Created by dave on 3/21/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import "RemoteEngine.h"
#import "Preferences.h"

@implementation RemoteEngine



-(MKNetworkOperation*) login:(NSString *)username password:(NSString *)password{

    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"account/sign_in.json"]
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      nil]
                                          httpMethod:@"POST"];
    
    [self enqueueOperation:op];
    return op;
}

-(MKNetworkOperation*) createTopic:(NSString *)title body:(NSString *)body node_id:(NSNumber *)node_id{
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"/api/v2/topics.json"]
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      body, @"body",
                                                      title, @"title",
                                                      node_id, @"node_id",
                                                      [Preferences privateToken], @"token",
                                                      nil]
                                          httpMethod:@"POST"];
    
    [self enqueueOperation:op];
    return op;
}

-(MKNetworkOperation*) topics:(NSNumber *)page{
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"/api/v2/topics.json"]
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      page, @"page",
                                                      nil]
                                          httpMethod:@"GET"];
    
    [self enqueueOperation:op forceReload:YES];
    return op;
}

-(MKNetworkOperation*) userTopics:(NSNumber *)page login:(NSString *)login{
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"/api/v2/users/%@/topics.json", login]
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      page, @"page",
                                                      nil]
                                          httpMethod:@"GET"];
    
    [self enqueueOperation:op];
    return op;
}


-(MKNetworkOperation*) topic:(NSNumber *)topicId{
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"/api/v2/topics/%@.json", topicId]
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      nil]
                                          httpMethod:@"GET"];
    
    [self enqueueOperation:op];
    return op;
}

-(MKNetworkOperation*) createReply:(NSNumber *)topicId body:(NSString *)body {
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"/api/v2/topics/%@/replies.json", topicId]
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      body, @"body",
                                                      [Preferences privateToken], @"token",
                                                      nil]
                                          httpMethod:@"POST"];
    
    [self enqueueOperation:op];
    return op;
}

-(MKNetworkOperation*) nodes{
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"/api/v2/nodes.json"]
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      nil]
                                          httpMethod:@"GET"];
    
    [self enqueueOperation:op];
    return op;
}

-(MKNetworkOperation*) node:(NSNumber *)nodeId{
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"/api/v2/topics/node/%@.json", nodeId]
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      nil]
                                          httpMethod:@"GET"];
    
    [self enqueueOperation:op];
    return op;
}

-(MKNetworkOperation*) user:(NSString *)username{
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"/api/v2/users/%@.json", username]
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      nil]
                                          httpMethod:@"GET"];
    
    [self enqueueOperation:op];
    return op;
}

@end
