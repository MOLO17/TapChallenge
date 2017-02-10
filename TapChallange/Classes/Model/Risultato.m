//
//  Risultati.m
//  TapChallenge
//
//  Created by Daniele Angeli on 10/02/17.
//  Copyright © 2017 MOLO17 Srl. All rights reserved.
//

#import "Risultato.h"

@implementation Risultato

-(id)initWithScore:(NSInteger)score andCreationDate:(NSDate *)date {
    self = [super init];
    
    if (self) {
        _score = score;
        _date = date;
    }
    
    return self;
}

@end
