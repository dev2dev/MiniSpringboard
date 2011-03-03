#import "MiniAppViewController.h"
#import "MiniSpringboardViewController.h"

@implementation MiniAppViewController

@synthesize appLabel = appLabel_;
@synthesize appName = appName_;
@synthesize springboard = springboard_;

- (void)dealloc {
  [appName_ release], appName_ = nil;
  [appLabel_ release], appLabel_ = nil;
  [super dealloc];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.appLabel.text = self.appName;
}

- (void)setAppName:(NSString *)name {
  [appName_ autorelease];
  appName_ = [name copy];
  self.appLabel.text = name;
}

- (void)quitApp {
  [self.springboard quitActiveApp];
}

@end
