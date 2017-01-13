//
//  ViewController.m
//  TapChallange
//
//  Created by Daniele Angeli on 13/01/17.
//  Copyright © 2017 MOLO17 Srl. All rights reserved.
//

#import "ViewController.h"

#define GameTimer 2

@interface ViewController () {
    int _tapsCount;
    
    NSTimer *_gameTimer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tapsCountLabel.minimumScaleFactor = 0.5;
    [self.tapsCountLabel setAdjustsFontSizeToFitWidth:true];
    
    [self initializeGame];
}

-(void)initializeGame {
    _tapsCount = 0;
    
    [self.tapsCountLabel setText:@"Tap to Play"];
}

#pragma mark - Actions

-(IBAction)buttonPressed:(id)sender {
    NSLog(@"buttonPressed: %i", _tapsCount);
    
    _gameTimer = [NSTimer scheduledTimerWithTimeInterval:GameTimer target:self selector:@selector(timerTick) userInfo:nil repeats:true];
    
    _tapsCount++;
    
    [self.tapsCountLabel setText:[NSString stringWithFormat:@"%i", _tapsCount]];
}

-(void)timerTick {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
