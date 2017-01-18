//
//  ViewController.h
//  TapChallange
//
//  Created by Daniele Angeli on 13/01/17.
//  Copyright © 2017 MOLO17 Srl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *tapsCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

-(IBAction)buttonPressed:(id)sender;

-(IBAction)tapGestureRecognizerDidRecognizeTap:(id)sender;

@end
