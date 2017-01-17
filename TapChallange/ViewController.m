//
//  ViewController.m
//  TapChallange
//
//  Created by Daniele Angeli on 13/01/17.
//  Copyright © 2017 MOLO17 Srl. All rights reserved.
//

#import "ViewController.h"

#import <Foundation/Foundation.h>

#define GameTimer 1
#define GameTime 3
#define FirstAppLaunch @"FirstAppLaunch"

@interface ViewController () {
    int _tapsCount;
    int _timeCount;
    
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

-(void)viewDidAppear:(BOOL)animated {
    if ([self firstAppLaunch] == false) {
        // app appena installata
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:FirstAppLaunch];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        int risultato = [self risultato];
        if (risultato > 0) {
            [self mostraUltimoRisultato:risultato];
        }
    }
}

-(void)initializeGame {
    _tapsCount = 0;
    _timeCount = GameTime;
    
    [self.tapsCountLabel setText:@"Tap to Play"];
    [self.timeLabel setText:[NSString stringWithFormat:@"Tap Challenge - %i sec", _timeCount]];
}

#pragma mark - Actions

-(IBAction)buttonPressed:(id)sender {
    // loggo in console il valore dei taps effettuati
    NSLog(@"buttonPressed: %i", _tapsCount);
    
    // questo è un commento singleline
    /*
     questo è un commento multiline
     */
    
    // creo il timer solo se serve
    if (_gameTimer == nil) {
        _gameTimer = [NSTimer scheduledTimerWithTimeInterval:GameTimer target:self selector:@selector(timerTick) userInfo:nil repeats:true];
    }
    
    // incremento il mio taps counter
    _tapsCount++;
    
    // aggiorno il valore della label
    [self.tapsCountLabel setText:[NSString stringWithFormat:@"%i", _tapsCount]];
}

-(void)timerTick {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    _timeCount--;
    
    [self.timeLabel setText:[NSString stringWithFormat:@"%i sec", _timeCount]];
    
    // game over
    if (_timeCount == 0) {
        [_gameTimer invalidate];
        _gameTimer = nil;
        
        NSString *message = [NSString stringWithFormat:@"Hai fatto %i Taps!", _tapsCount];
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Game Over" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // salvo i dati utente
            [self salvaRisultato];
            
            // inizializzo tutte le variabili di gioco al loro valore iniziale
            [self initializeGame];
        }];
        
        [alertViewController addAction:okAction];
        [self presentViewController:alertViewController animated:true completion:nil];
    }
}

#pragma mark - UI

-(void)mostraUltimoRisultato:(int)risultato {
    // voglio che un UIAlertController mi mostri al primo avvio dell'app il precedente risultato del mio utente
    
    NSString *message = [NSString stringWithFormat:@"Hai fatto %i Taps!", risultato];
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Game Over" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // non faccio nulla?!
    }];
    
    [alertViewController addAction:okAction];
    [self presentViewController:alertViewController animated:true completion:nil];
}

#pragma mark - Persistenza

-(int)risultato {
    // ricavo i dati salvati dagli userDefaults
    int value = [[NSUserDefaults standardUserDefaults] integerForKey:@"TapsCount"];
    
    // loggo la variabile "value"
    NSLog(@"VALORE DAGLI USER DEFAULTS -> %i", value);
    
    return value;
}

-(void)salvaRisultato {
    [[NSUserDefaults standardUserDefaults] setInteger:_tapsCount forKey:@"TapsCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(bool)firstAppLaunch {
    return [[NSUserDefaults standardUserDefaults] boolForKey:FirstAppLaunch];
}

@end
