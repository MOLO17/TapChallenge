//
//  ViewController.m
//  TapChallange
//
//  Created by Daniele Angeli on 13/01/17.
//  Copyright © 2017 MOLO17 Srl. All rights reserved.
//

#import "GameViewController.h"
#import "ScoreTableViewController.h"

#import <Foundation/Foundation.h>

#define GameTimer 1
#define GameTime 30
#define FirstAppLaunch @"FirstAppLaunch"

#define Defaults [NSUserDefaults standardUserDefaults]
#define Results @"UserScore"

@interface GameViewController () {
    int _tapsCount;
    int _timeCount;
    
    NSTimer *_gameTimer;
}

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tapsCountLabel.minimumScaleFactor = 0.5;
    [self.tapsCountLabel setAdjustsFontSizeToFitWidth:true];
    
    [self initializeGame];
    
    // Setto il navigation bar title
    self.title = @"Tap Challenge";
    
    // creo un pulsante che andrò a mettere dentro la NavigationBar
    UIBarButtonItem *scoreButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(scoreButtonPressed)];
    
    // imposto il pulsante come elemento alla DX della mia navigationBar
    self.navigationItem.rightBarButtonItem = scoreButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
    if ([self firstAppLaunch] == false) {
        // app appena installata
        [Defaults setBool:true forKey:FirstAppLaunch];
        [Defaults synchronize];
    }
    else {
        if ([self risultati].count > 0) {
            NSNumber *value = [self risultati].lastObject;
            [self mostraUltimoRisultato:value.intValue];
        }
    }
}

-(void)initializeGame {
    _tapsCount = 0;
    _timeCount = GameTime;
    
    [self.tapsCountLabel setText:@"Tap to Play"];
    [self.timeLabel setText:[NSString stringWithFormat:@"Ti restano %i sec", _timeCount]];
}

#pragma mark - Actions

-(void)scoreButtonPressed {
    /*
    // es. creazione di un ViewController da codice
    UIViewController *viewController = [[UIViewController alloc] init];
    // setto il titolo
    viewController.title = @"nuovo";
    // personalizzo il colore dello sfondo
    viewController.view.backgroundColor = [UIColor redColor];
     */
    
    // prendo dalla storyboard il mio VC con storyBoardID "ScoreTableViewController"
    ScoreTableViewController *tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreTableViewController"];
    
    // pusho all'interno dello stack del mio navigationController un nuovo ViewController
    [self.navigationController pushViewController:tableViewController animated:true];
}

-(IBAction)tapGestureRecognizerDidRecognizeTap:(id)sender {
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

-(IBAction)buttonPressed:(id)sender {
    //
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
    
    NSString *message = [NSString stringWithFormat:@"Il tuo miglior risultato: %i Taps!", risultato];
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Wall of fame" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // non faccio nulla?!
    }];
    
    [alertViewController addAction:okAction];
    [self presentViewController:alertViewController animated:true completion:nil];
}

#pragma mark - Persistenza

-(NSArray *)risultati {
    // ricavo i dati salvati dagli userDefaults
    NSArray *array = [Defaults objectForKey:Results];
    
    if (array == nil) {
        array = @[]; // inizializzo un array STATICO
    }
    
    // loggo la variabile "array"
    NSLog(@"VALORE DAGLI USER DEFAULTS -> %@", array);
    
    return array;
}

-(void)salvaRisultato {
    NSMutableArray *array = [[Defaults objectForKey:Results] mutableCopy];
    if (array == nil) {
        // OLD way
        //array = [[NSMutableArray alloc] init].mutableCopy;
        
        // NEW fashion way
        array = @[].mutableCopy;
    }
    
    // OLD way
//    NSNumber *number = [NSNumber numberWithInt:_tapsCount];
    
    // NEW fashion way
    [array addObject:@(_tapsCount)];
    
    NSLog(@"mio array -> %@", array);
    
    NSArray *arrayToBeSaved = [array sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber  *obj2) {
        int value1 = obj1.intValue;
        int value2 = obj2.intValue;
        
        if (value1 == value2) {
            return NSOrderedSame;
        }
        
        if (value1 < value2) {
            return NSOrderedAscending;
        }
        
        return NSOrderedDescending;
    }];
    
    [Defaults setObject:arrayToBeSaved forKey:Results];
    [Defaults synchronize];
}

-(bool)firstAppLaunch {
    return [[NSUserDefaults standardUserDefaults] boolForKey:FirstAppLaunch];
}

@end
