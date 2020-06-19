//   AppDelegate.m
//   AppBackgroundActive
//   
//   Created  by Geeks_Chen on 2020/6/19
//   Copyright © 2020 MJDev. All rights reserved.

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgrounTask;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
 
    NSLog(@"EnterBackground");
    //创建一个背景任务去和系统请求后台运行的时间
    self.backgrounTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgrounTask];
        self.backgrounTask = UIBackgroundTaskInvalid;
    }];
    
    if (!self.timer.valid) {
        [self addTimerForBackgroundJob];
    }
}

- (void)addTimerForBackgroundJob {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5. target:self selector:@selector(doBackgroundJob) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)doBackgroundJob {
    
    if ([UIApplication sharedApplication].backgroundTimeRemaining < 30.0) {//如果剩余时间小于30秒
        [[UIApplication sharedApplication] endBackgroundTask:self.backgrounTask];
        self.backgrounTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:self.backgrounTask];
            self.backgrounTask = UIBackgroundTaskInvalid;
        }];
    }
    NSLog(@"======doJob======");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"app killed");
    [self.timer invalidate];
}
@end
