//
//  ViewController.m
//  TapChallange
//
//  Created by Daniele Angeli on 13/01/17.
//  Copyright © 2017 MOLO17 Srl. All rights reserved.
//

#import "GameViewController.h"
#import "ScoreTableViewController.h"
#import "Risultato.h"

#import <Foundation/Foundation.h>

#define GameTimer 1
#define GameTime 2
#define FirstAppLaunch @"FirstAppLaunch"

#define Defaults [NSUserDefaults standardUserDefaults]
#define Results @"UserScore"

@interface GameViewController () {
    int _tapsCount;
    int _timeCount;
    
    NSTimer *_gameTimer;
    
    UILabel *_nuovaLabel;
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
    
    // creo un nuovo oggetto label e lo inserisco direttamente da codice
    _nuovaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 200, 40)];
    [_nuovaLabel setText:@"nuova LABEL da codice"];
    [_nuovaLabel setBackgroundColor:[UIColor redColor]];
    [_nuovaLabel setTextColor:[UIColor whiteColor]];
    [_nuovaLabel setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:_nuovaLabel];
    
    NSDictionary *dictionary = [Defaults objectForKey:@"myDictionary"];
    if (dictionary != nil) {
        NSLog(@"dictionary salvato in precedenza -> %@", dictionary);
        
        NSLog(@"valori nel dictionary: %@", dictionary.allValues);
        
        NSLog(@"chiavi nel dictionary: %@", dictionary.allKeys);
        
        NSLog(@"score: %@\nDate: %@", dictionary[@"score"], dictionary[@"date"]);
        
        Risultato *risultato = [[Risultato alloc] initWithScore:[dictionary[@"score"] integerValue] andCreationDate:dictionary[@"date"]];
        NSLog(@"risutato: %li", risultato.score);
    }
}

-(void)viewDidAppear:(BOOL)animated {
    /*
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
    }*/
    
    [self resumeGame];
    
//    [UIView animateWithDuration:5 animations:^{
//        [_nuovaLabel setCenter:CGPointMake(300, 500)];
//        
//        [_nuovaLabel setAlpha:0];
//    }];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self pauseGame];
}

-(void)initializeGame {
    _tapsCount = 0;
    _timeCount = GameTime;
    
    [self.tapsCountLabel setText:@"Tap to Play"];
    [self.timeLabel setText:[NSString stringWithFormat:@"Ti restano %i sec", _timeCount]];
}

#pragma mark - Play / Pause game

-(void)pauseGame {
    if (_gameTimer != nil) {
        [_gameTimer invalidate];
        _gameTimer = nil;
    }
}

-(void)resumeGame {
    if (_timeCount != 0 && _tapsCount > 0) {
        _gameTimer = [NSTimer scheduledTimerWithTimeInterval:GameTimer target:self selector:@selector(timerTick) userInfo:nil repeats:true];
    }
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
    
    // prendo i risultati del mio utente e li passo allo scoreVC
//    NSArray *resultsArray = [self risultati];
//    [tableViewController setScoresArray:resultsArray];
    
    // instauro il collegamento tra GameVC e ScoreVC attraverso il Delegate
    tableViewController.delegate = self;
    
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
    
    NSDate *dataCorrente = [NSDate date];
    NSLog(@"Data corrente: %@", dataCorrente);
    
    Risultato *risultato = [[Risultato alloc] initWithScore:_tapsCount andCreationDate:dataCorrente];
    
    NSDictionary *dictionary = @{ @"score": @(risultato.score), @"date": risultato.date };
    NSLog(@"dictionary: %@", dictionary);
    
    [Defaults setObject:dictionary forKey:@"myDictionary"];
    [Defaults synchronize];
}

-(bool)firstAppLaunch {
    return [[NSUserDefaults standardUserDefaults] boolForKey:FirstAppLaunch];
}

#pragma mark - ScoreTableViewDelegate

-(NSArray *)scoreTableViewFetchResults {
    return [self risultati];
}

-(void)scoreTableViewDidFetchResults {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
