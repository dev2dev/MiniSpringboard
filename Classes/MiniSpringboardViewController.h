
@class MiniAppViewController;

@interface MiniSpringboardViewController : UIViewController {
}

@property (nonatomic, retain) IBOutlet MiniAppViewController *activeApp;

- (void)quitActiveApp;

@end

