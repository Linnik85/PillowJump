//
//  ALPlayer.h
//  PillowJump
//
//  Created by Линник Александр on 22.03.14.
//  Copyright (c) 2014 Alex Linnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ALPlayer : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * score;

@end
