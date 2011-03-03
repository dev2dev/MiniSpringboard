#import "MiniSpringboardViewController.h"
#import "MiniAppViewController.h"

@interface MiniSpringboardViewController()

- (CGAffineTransform)offscreenQuadrantTransformForView:(UIView *)theView;
- (void)handlePress:(UILongPressGestureRecognizer *)recognizer;
- (void)handleIconTap:(UITapGestureRecognizer *)recognizer;

@end

@implementation MiniSpringboardViewController

@synthesize activeApp = activeApp_;

- (void)dealloc {
  [activeApp_ release], activeApp_ = nil;
  [super dealloc];
}

- (void)viewDidLoad {
  for(UIView *thumbnail in self.view.subviews) {
    UILongPressGestureRecognizer *longPress = 
      [[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                    action:@selector(handlePress:)];
    [thumbnail addGestureRecognizer:longPress];
    [longPress release];
    
    UITapGestureRecognizer *tapGesture = 
      [[UITapGestureRecognizer alloc] initWithTarget:self 
                                              action:@selector(handleIconTap:)];
    [thumbnail addGestureRecognizer:tapGesture];
    [tapGesture release];
  }
}

- (void)viewDidUnload {
  for(UIView *thumbnail in self.view.subviews) {
    for(UIGestureRecognizer *recognizer in thumbnail.gestureRecognizers) {
      [thumbnail removeGestureRecognizer:recognizer];
    }
  }
}

- (void)viewWillAppear:(BOOL)animated {
  //Translate each view based on its quadrant on screen and set its alpha to 0
  for(UIView *thumbnail in self.view.subviews) {
    thumbnail.transform = [self offscreenQuadrantTransformForView:thumbnail];
    thumbnail.alpha = 0.f;
  }
}

- (void)viewDidAppear:(BOOL)animated {
  //Animate the view transforms back to the identity and their alpha values to 1
  [UIView animateWithDuration:.3f animations:^{
    for (UIView *thumbnail in self.view.subviews) {
      thumbnail.transform = CGAffineTransformIdentity;
      thumbnail.alpha = 1.f;
    }
  }];
}

- (CGAffineTransform)offscreenQuadrantTransformForView:(UIView *)theView {
  CGPoint parentMidpoint = CGPointMake(CGRectGetMidX(theView.superview.bounds), 
                                       CGRectGetMidY(theView.superview.bounds));
  CGFloat xSign = (theView.center.x < parentMidpoint.x) ? -1.f : 1.f;
  CGFloat ySign = (theView.center.y < parentMidpoint.y) ? -1.f : 1.f;
  return CGAffineTransformMakeTranslation(xSign * parentMidpoint.x, 
                                          ySign * parentMidpoint.y);
}

- (void)handlePress:(UILongPressGestureRecognizer *)recognizer {
  if(recognizer.state == UIGestureRecognizerStateBegan) {
    CGFloat rotationRadians = 5.f * M_PI / 180.f;
    for (UIView *thumbnail in self.view.subviews) {
      thumbnail.transform = CGAffineTransformMakeRotation(-rotationRadians);
      [UIView animateWithDuration:.1f 
                            delay:0.f 
                          options:UIViewAnimationOptionRepeat | 
                                  UIViewAnimationOptionAutoreverse | 
                                  UIViewAnimationOptionAllowUserInteraction
                       animations:
       ^{
         thumbnail.transform = CGAffineTransformMakeRotation(rotationRadians);
       } completion:nil];
    }
  }
  if(recognizer.state == UIGestureRecognizerStateEnded) {
    [UIView animateWithDuration:0.f animations:^{
      for (UIView *thumbnail in self.view.subviews) {
        thumbnail.transform = CGAffineTransformIdentity;
      }
    }];
  }
}

- (void)handleIconTap:(UITapGestureRecognizer *)recognizer {
  UILabel *tappedLabel = (UILabel *)recognizer.view;
  self.activeApp.appName = tappedLabel.text;
  self.activeApp.view.alpha = 0.f;
  self.activeApp.view.transform = CGAffineTransformMakeScale(.1f, .1f);
  [self.view addSubview:self.activeApp.view];
  
  [UIView animateWithDuration:.3f  animations:^{
    for(UIView *thumbnail in self.view.subviews) {
      if(thumbnail != self.activeApp.view) {
        thumbnail.transform = [self offscreenQuadrantTransformForView:thumbnail];
        thumbnail.alpha = 0.f;
      }
    }
    self.activeApp.view.alpha = 1.f;
    self.activeApp.view.transform = CGAffineTransformIdentity;
  }];
}

- (void)quitActiveApp {
  [UIView animateWithDuration:.3f animations:^{
    self.activeApp.view.alpha = 0.f;
    self.activeApp.view.transform = CGAffineTransformMakeScale(.1f, .1f);
    for(UIView *thumbnail in self.view.subviews) {
      if(thumbnail != self.activeApp.view) {
        thumbnail.transform = CGAffineTransformIdentity;
        thumbnail.alpha = 1.f;
      }
    }
  } completion:^(BOOL finished) {
    [self.activeApp.view removeFromSuperview];
  }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return NO;
}
@end
