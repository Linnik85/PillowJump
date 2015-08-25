//
//  ALMyScene.m
//  PillowJump
//
//  Created by Линник Александр on 02.03.14.
//  Copyright (c) 2014 Alex Linnik. All rights reserved.
//

#import "ALMyScene.h"
#import "ALStartScene.h"
#import "ALPlayer.h"

static const uint32_t circleCategory     =  0x1 << 0;
static const uint32_t jumperCategory     =  0x1 << 1;
static const uint32_t noCollision        =  0x1 << 2;

@interface ALMyScene()

@property (strong, nonatomic) SKSpriteNode *jumper;
@property (strong, nonatomic) SKSpriteNode* jumperContactBody;

@property (strong, nonatomic) SKNode* jumperContainer;
@property (strong, nonatomic) SKNode* jumperGroup;

@property (strong, nonatomic) SKSpriteNode *circle;
@property (strong, nonatomic) SKSpriteNode *platform;
@property (strong, nonatomic) SKSpriteNode *circleWithSpikes;
@property (strong, nonatomic) SKSpriteNode *pillow;


@property (strong, nonatomic) SKNode *container;
@property (strong, nonatomic) SKNode *group;


@property (assign, nonatomic) BOOL firstRotation;
@property (assign, nonatomic) BOOL jumpDown;


@property (strong, nonatomic) SKLabelNode* scoreLable;
@property (strong, nonatomic) SKLabelNode* speedLable;

@property (assign, nonatomic) NSInteger score;
@property (assign, nonatomic) NSInteger oldScore;

@property (nonatomic) NSTimeInterval upTimeInterval;
@property (nonatomic) NSTimeInterval startTimeInterval;


@property (strong, nonatomic) SKSpriteNode* backMenuButton;
@property (strong, nonatomic) NSArray* birdTextures;

@property (nonatomic, strong) AVAudioPlayer* musicPlayer;

@property (assign, nonatomic) BOOL missedFlag;
@property (assign, nonatomic) BOOL colled;

@property (strong, nonatomic) SKSpriteNode *yesButton;
@property (strong, nonatomic) SKSpriteNode *noButton;
@property (strong, nonatomic) SKLabelNode* yourScoreLable;
@property (strong, nonatomic) SKLabelNode* playAgainLable;

@property (strong, nonatomic) UISwipeGestureRecognizer* upSwipeGesture;
@property (strong, nonatomic) UISwipeGestureRecognizer* downSwipeGesture;

@property (assign, nonatomic) NSUserDefaults* userDefaults;

@end

@implementation ALMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.jumpDown = NO;

        self.userDefaults = [NSUserDefaults standardUserDefaults];
        self.missedFlag = NO;
        self.firstRotation = YES;
        self.startTimeInterval = 1.0;
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"cartoon-natural"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
       
        [self addPlatform];
        
        [self addScoreLable];
        
        [self addSpeedLable];
        
        [self addJumper];
   
        self.circle = [SKSpriteNode spriteNodeWithImageNamed:@"circle2"];
        self.circle.position = CGPointMake(160, CGRectGetMaxY(self.frame)/2);
        [self addChild:self.circle];
        
        [self addBackMenuButton];
        
        [self addyourScoreLable];
        
        [self addplayAgainLable];
        
        
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.upSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                                   action:@selector(handleUpSwipe:)];
    self.upSwipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:self.upSwipeGesture];
    
    self.downSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                                     action:@selector(handleDownSwipe:)];
    self.downSwipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:self.downSwipeGesture];
    
    
   
}

-(void) handleUpSwipe: (UISwipeGestureRecognizer*) upSwipeGesture{
    
    self.platform.physicsBody.categoryBitMask = circleCategory;
    self.platform.physicsBody.contactTestBitMask = jumperCategory;
    
    self.jumpDown = YES;

    self.missedFlag = NO;

    
    if (self.firstRotation) {
        
        SKAction *pause = [SKAction waitForDuration: 0.2];
        SKAction *action = [SKAction rotateByAngle:-M_PI*2 duration:self.startTimeInterval];
        SKAction *repeatRotate = [SKAction repeatActionForever:action];
        
        SKAction *sequence = [SKAction sequence:@[pause,repeatRotate]];
        
        NSString* musicPath = [[NSBundle mainBundle] pathForResource:@"swipe" ofType:@"mp3"];
        [self playSound:musicPath];
        
        [self.container runAction:sequence];
        self.firstRotation = NO;
        
        
        if (self.startTimeInterval>=0.4 && self.oldScore!=self.score ) {
            
            if (self.score == 2 ) {
                
                self.startTimeInterval = self.startTimeInterval - 0.1;
                
                self.speedLable.text =[NSString stringWithFormat:@"Speed: 2"];
            }
            if (self.score == 4) {
                
                self.startTimeInterval = self.startTimeInterval - 0.1;
                
                self.speedLable.text =[NSString stringWithFormat:@"Speed: 3"];
            }
            if (self.score == 6) {
                
                self.startTimeInterval = self.startTimeInterval - 0.1;
                
                self.speedLable.text =[NSString stringWithFormat:@"Speed: 4"];
            }
            if (self.score == 8) {
                
                self.startTimeInterval = self.startTimeInterval - 0.1;
                
                self.speedLable.text =[NSString stringWithFormat:@"Speed: 5"];
            }
            if (self.score == 10) {
                
                self.startTimeInterval = self.startTimeInterval - 0.1;
                
                self.speedLable.text =[NSString stringWithFormat:@"Speed: 6"];
            }
            if (self.score == 12) {
                
                self.startTimeInterval = self.startTimeInterval - 0.1;
                
                self.speedLable.text =[NSString stringWithFormat:@"Speed: 7"];
            }
        }
        self.oldScore = self.score;

        
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Bird"];
        SKTexture *f1 = [atlas textureNamed:@"Bird_1"];
        SKTexture *f2 = [atlas textureNamed:@"Bird_2"];
        
        self.birdTextures = @[f1,f2];
        SKAction *walkAnimation = [SKAction animateWithTextures:self.birdTextures
                                                   timePerFrame:0.1];
        [self.jumper runAction:walkAnimation];

    }

    
    SKAction * actionMove = [SKAction moveTo:CGPointMake(160, CGRectGetMaxY(self.frame)/2) duration:0.2];
    
    [self.jumperContainer runAction:actionMove];
}

-(void) handleDownSwipe: (UISwipeGestureRecognizer*) downSwipeGesture{
    
    if ( self.jumpDown) {
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake (160, CGRectGetMaxY(self.frame)/2-88) duration:0.02];
        SKAction* removActions = [SKAction performSelector:@selector(removActions) onTarget:self];
        SKAction *sequence = [SKAction sequence:@[actionMove,removActions]];
        [self.jumperContainer runAction:sequence];
        
    }
    
}


-(void)update:(CFTimeInterval)currentTime {
    
    
    }


-(void)didBeginContact:(SKPhysicsContact *)contact{
    
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & circleCategory) != 0 && (secondBody.categoryBitMask & jumperCategory) != 0)
    {
        [self.container removeAllActions];
        
        self.missedFlag = YES;
        self.score ++;
        self.firstRotation = YES;
        self.scoreLable.text =[NSString stringWithFormat:@"Score: %ld", (long)self.score];
        
        NSString* musicPath = [[NSBundle mainBundle] pathForResource:@"popadanie" ofType:@"mp3"];
        [self playSound:musicPath];
        
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode* node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"backMenuButton"]) {
        
        
        SKTexture* texture = [SKTexture textureWithImageNamed:@"menuButton-selected"];
        SKAction* changeTexture = [SKAction setTexture:texture];
        [node runAction:changeTexture];
    }
    
    if ([node.name isEqualToString:@"noButton"]) {
        
        SKTexture* texture = [SKTexture textureWithImageNamed:@"noButton-sel"];
        SKAction* changeTexture = [SKAction setTexture:texture];
        [node runAction:changeTexture];
    }
    
    if ([node.name isEqualToString:@"yesButton"]) {
        
        SKTexture* texture = [SKTexture textureWithImageNamed:@"yesButton-sel"];
        SKAction* changeTexture = [SKAction setTexture:texture];
        [node runAction:changeTexture];
    }
    
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode* node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"backMenuButton"]) {
        
        [self.view removeGestureRecognizer:self.upSwipeGesture];
        [self.view removeGestureRecognizer:self.downSwipeGesture];
        
        ALStartScene* menu = [[ALStartScene alloc] initWithSize:CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
        
        SKTransition* transition = [SKTransition crossFadeWithDuration:0.3];
        [self.scene.view presentScene:menu transition:transition];
    
    }
    if ([node.name isEqualToString:@"noButton"]) {
        
        [self.view removeGestureRecognizer:self.upSwipeGesture];
        [self.view removeGestureRecognizer:self.downSwipeGesture];
        
        ALStartScene* menu = [[ALStartScene alloc] initWithSize:CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
        
        SKTransition* transition = [SKTransition crossFadeWithDuration:0.3];
        [self.scene.view presentScene:menu transition:transition];
    }
    
    if ([node.name isEqualToString:@"yesButton"]) {
        
        [self startGame];
        
    } else {
        
        SKTexture* texture = [SKTexture textureWithImageNamed:@"menuButton"];
        SKAction* changeTextureMenuButton = [SKAction setTexture:texture];
        [self.backMenuButton runAction:changeTextureMenuButton];
        
        SKTexture* texture2 = [SKTexture textureWithImageNamed:@"noButton"];
        SKAction* changeTextureNoButton = [SKAction setTexture:texture2];
        [self.noButton runAction:changeTextureNoButton];
        
        SKTexture* texture3 = [SKTexture textureWithImageNamed:@"yesButton"];
        SKAction* changeTexturYesButton= [SKAction setTexture:texture3];
        [self.yesButton runAction:changeTexturYesButton];
        
    }
}



#pragma mark Initialization methods

-(void) addScoreLable{
    
    self.scoreLable = [SKLabelNode labelNodeWithFontNamed:@"TimesNewRoman"];
    self.scoreLable.text =[NSString stringWithFormat:@"Score: %ld", (long)self.score];
    self.scoreLable.position = CGPointMake(50, CGRectGetMaxY(self.frame)-68);
    self.scoreLable.fontSize =20;
    self.scoreLable.fontColor =[UIColor yellowColor];

    [self addChild:self.scoreLable];
    
}

-(void) addPlatform{
    
    self.platform = [[SKSpriteNode alloc]initWithColor:[UIColor greenColor] size:CGSizeMake(55, 20)];
    self.platform.position = CGPointMake(120, 12);
    self.platform.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.platform.size];
    self.platform.physicsBody.dynamic = YES;
    self.platform.physicsBody.categoryBitMask = circleCategory;
    self.platform.physicsBody.contactTestBitMask = jumperCategory;
    self.platform.physicsBody.collisionBitMask = 0;
    
    
    self.pillow = [SKSpriteNode spriteNodeWithImageNamed:@"platform2"];
    self.pillow.position = CGPointMake(120, 8);
    
    
    self.circleWithSpikes = [[SKSpriteNode alloc]initWithColor:[UIColor clearColor] size:CGSizeMake(240, 240)];
    self.circleWithSpikes.anchorPoint = CGPointMake(0, 0);
    self.circleWithSpikes.position = CGPointMake(0,0);
    
    
    self.container = [[SKNode alloc]init];
    self.group = [[SKNode alloc]init];
    [self.group addChild:self.platform];
    [self.group addChild:self.pillow];
    
    [self.group addChild:self.circleWithSpikes];
    
    
    CGRect groupRect = [self.group calculateAccumulatedFrame];
    self.group.position = CGPointMake(-groupRect.size.width/2, -groupRect.size.height/2);
    [self.container addChild:self.group];
    self.container.position = CGPointMake(160, CGRectGetMaxY(self.frame)/2);
    [self addChild:self.container];

}

-(void) addJumper{
    
    self.jumper = [SKSpriteNode spriteNodeWithImageNamed:@"Bird_2"];
    self.jumper.anchorPoint = CGPointMake(0, 0);
    
    self.jumperContactBody = [[SKSpriteNode alloc]initWithColor:[UIColor clearColor] size:CGSizeMake(45, 20)];
    self.jumperContactBody.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.jumperContactBody.size];
    self.jumperContactBody.physicsBody.dynamic = NO;
    self.jumperContactBody.physicsBody.categoryBitMask = jumperCategory;
    self.jumperContactBody.physicsBody.contactTestBitMask = circleCategory;
    self.jumperContactBody.physicsBody.collisionBitMask = 0;
    self.jumperContactBody.position = CGPointMake(self.jumper.size.width/2,16);
    
    
    self.jumperContainer =[[SKNode alloc]init];
    self.jumperGroup =[[SKNode alloc]init];
    [self.jumperGroup addChild:self.jumper];
    [self.jumperGroup addChild:self.jumperContactBody];
    
    CGRect groupRect2 = [self.jumperGroup calculateAccumulatedFrame];
    self.jumperGroup.position = CGPointMake(-groupRect2.size.width/2, -groupRect2.size.height/2);
    [self.jumperContainer addChild:self.jumperGroup];
    self.jumperContainer.position = CGPointMake(160, (CGRectGetMaxY(self.frame)/2)-70);
    [self addChild:self.jumperContainer];

}


-(void) addyourScoreLable{
    
    self.yourScoreLable = [SKLabelNode labelNodeWithFontNamed:@"TimesNewRoman"];
    self.yourScoreLable.text =[NSString stringWithFormat:@"Your score: %ld", (long)self.score];
    self.yourScoreLable.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+20);
    self.yourScoreLable.fontSize =20;
    self.yourScoreLable.fontColor =[UIColor yellowColor];
    self.yourScoreLable.hidden = YES;
    [self addChild:self.yourScoreLable];
    
}


-(void) addSpeedLable {
    
    self.speedLable = [SKLabelNode labelNodeWithFontNamed:@"TimesNewRoman"];
    self.speedLable.text =[NSString stringWithFormat:@"Speed: 1"];
    self.speedLable.position = CGPointMake(270, CGRectGetMaxY(self.frame)-68);
    self.speedLable.fontSize =20;
    self.speedLable.fontColor =[UIColor yellowColor];

    [self addChild:self.speedLable];
}

-(void) addplayAgainLable {
    
    self.playAgainLable = [SKLabelNode labelNodeWithFontNamed:@"TimesNewRoman"];
    self.playAgainLable.text =[NSString stringWithFormat:@"Play again?"];
    self.playAgainLable.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-10);
    self.playAgainLable.fontSize =20;
    self.playAgainLable.hidden = YES;
    self.playAgainLable.fontColor =[UIColor yellowColor];
    
    [self addChild:self.playAgainLable];
}



-(void) addBackMenuButton{
    
    
    self.backMenuButton = [SKSpriteNode spriteNodeWithImageNamed:@"menuButton"];
    self.backMenuButton.position = CGPointMake(70, CGRectGetMinY(self.frame)+50);
    self.backMenuButton.name = @"backMenuButton";
    [self addChild:self.backMenuButton];
}

- (void)vibrate {
    
    long vibrateDefaults = [self.userDefaults integerForKey:@"vibrate"];
    if (vibrateDefaults == 1) {
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }

}


- (void) playSound : (NSString*) atPass{
    
    long soundDefaults = [self.userDefaults integerForKey:@"sound"];

     if (soundDefaults == 1) {
         [self.musicPlayer stop];
    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:atPass] error:NULL];
    self.musicPlayer.numberOfLoops = 1;
    self.musicPlayer.volume = 0.5;
    [self.musicPlayer play];
     }
}

-(void) addyesButton{
    
    self.yesButton = [SKSpriteNode spriteNodeWithImageNamed:@"yesButton"];
    self.yesButton.position = CGPointMake(CGRectGetMidX(self.frame)-50,CGRectGetMidY(self.frame)-47);
    self.yesButton.name = @"yesButton";
    self.yesButton.zPosition = 1;
    [self addChild:self.yesButton];
}

-(void) addnoButton{
    
    self.noButton = [SKSpriteNode spriteNodeWithImageNamed:@"noButton"];
    self.noButton.position = CGPointMake(CGRectGetMidX(self.frame)+50,CGRectGetMidY(self.frame)-47);
    self.noButton.name = @"noButton";
    self.noButton.zPosition = 1;

    [self addChild:self.noButton];
}


#pragma mark Game Actions


- (void) startGame {
    
    ALMyScene* game = [[ALMyScene alloc] initWithSize:CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
    
    SKTransition* transition = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.view presentScene:game transition:transition];

   }


- (void) endGame {
    
    [self savePlayer];
    
    [self vibrate];
    [self.view removeGestureRecognizer:self.upSwipeGesture];
    [self.view removeGestureRecognizer:self.downSwipeGesture];
    
    self.container.hidden = YES;
    self.scoreLable.hidden = YES;
    self.speedLable.hidden = YES;
    self.backMenuButton.hidden = YES;
    
    SKAction *blink = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.1],
                                           [SKAction fadeInWithDuration:0.1]]];
    SKAction *blinkForTime = [SKAction repeatAction:blink count:4];
    
    SKAction *removJumper = [SKAction fadeOutWithDuration:0.1];
    
    SKAction* addyourScoreLable = [SKAction performSelector:@selector(hiddenLableEndGame) onTarget:self];
    
    SKAction *sequence = [SKAction sequence:@[blinkForTime,removJumper,addyourScoreLable]];
    
    [self.jumperContainer runAction:sequence];

}


-(void) removActions{
    
     [self.container removeAllActions];
    
    self.platform.physicsBody.categoryBitMask = noCollision;
    self.platform.physicsBody.contactTestBitMask = noCollision;
    
    self.firstRotation = YES;
    
    if (!self.missedFlag) {
        
        [self endGame];
        
        self.platform.physicsBody.categoryBitMask = noCollision;
        self.platform.physicsBody.contactTestBitMask = noCollision;
    }
}

-(void) hiddenLableEndGame{
    
    self.yourScoreLable.text =[NSString stringWithFormat:@"Score: %ld", (long)self.score];
    
    [self addyesButton];
    
    [self addnoButton];

    self.yourScoreLable.hidden = NO;
    self.playAgainLable.hidden = NO;
    
}

#pragma mark Core Data

-(NSManagedObjectContext*) manageObjectContext {
    NSManagedObjectContext* context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void) savePlayer{
    
    if (self.score > 0) {
        
    
    NSManagedObjectContext* context = [self manageObjectContext];
    
    ALPlayer* newPlayer = [NSEntityDescription insertNewObjectForEntityForName:@"ALPlayer" inManagedObjectContext:context];
    
    if (![self.userDefaults objectForKey:@"name"]) {
        
         newPlayer.name = @"Player";
        
    }else{
         newPlayer.name = [self.userDefaults objectForKey:@"name"];
    }
   
    newPlayer.score = [NSNumber numberWithInteger:self.score];
    
    NSError* error = nil;
    
    if (![context save:&error]) {
        NSLog(@"Context can save! %@ %@", error, [error localizedDescription]);
        
    }
    }
}


@end
