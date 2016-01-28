#import "AFHTTPSessionManager+Util.h"

@implementation  AFHTTPSessionManager(Util)
+ (instancetype)ApiManager
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:[self generateUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    NSString *token=[self getToken];
    if (token) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", token] forHTTPHeaderField:@"Authorization"];
    }
    return manager;
}

+ (NSString *)generateUserAgent
{
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString *IDFV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    return [NSString stringWithFormat:@"git.OSChina.NET/git_%@/%@/%@/%@/%@",
            appVersion,
            [UIDevice currentDevice].systemName,
            [UIDevice currentDevice].systemVersion,
            [UIDevice currentDevice].model,
            IDFV];
}

+(NSString *)getToken
{
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    return token;
}


@end
