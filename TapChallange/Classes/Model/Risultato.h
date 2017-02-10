//
//  Risultati.h
//  TapChallenge
//
//  Created by Daniele Angeli on 10/02/17.
//  Copyright © 2017 MOLO17 Srl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Risultato : NSObject

-(id)initWithScore:(NSInteger)score andCreationDate:(NSDate *)date;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSDate *date;

@end
