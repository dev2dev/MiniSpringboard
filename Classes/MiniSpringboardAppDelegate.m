#import "MiniSpringboardAppDelegate.h"
#import "MiniSpringboardViewController.h"

@implementation MiniSpringboardAppDelegate

@synthesize window = window_;
@synthesize viewController = viewController_;

- (void)dealloc {
  [viewController_ release], viewController_ = nil;
  [window_ release], window_ = nil;
  [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
  [self.window addSubview:self.viewController.view];
  [self.window makeKeyAndVisible];
  return YES;
}

@end
