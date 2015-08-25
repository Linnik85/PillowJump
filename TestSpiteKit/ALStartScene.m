//
//  ALStartScene.m
//  PillowJump
//
//  Created by Линник Александр on 08.03.14.
//  Copyright (c) 2014 Alex Linnik. All rights reserved.
//

#import "ALStartScene.h"
#import "ALMyScene.h"
#import "ALSettingsScene.h"
#import "ALHighScoresTableViewController.h"
#import "ALHowToPlayScene.h"

@interface ALStartScene()


@property (retain, nonatomic) UIButton* startGameButton;
@property (retain, nonatomic) UIButton* highScoresButton;
@property (retain, nonatomic) UIButton* settingsButton;
@property (retain, nonatomic) UIButton* howToPlayButton;


@end

@implementation ALStartScene


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"startScene"];
        
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
    }
    return self;
}


-(void)didMoveToView:(SKView *)view{
  
    self.startGameButton= [UIButton buttonWithType:UIButtonTypeCustom];
    self.startGameButton.frame = CGRectMake(CGRectGetMidX(self.frame)-105, CGRectGetMaxY(self.frame)-360, 210, 50);
    UIImage* buttonImageNormal = [UIImage imageNamed:@"startButton"];
    UIImage* buttonImageSelected = [UIImage imageNamed:@"startButton---selected"];
    [self.startGameButton setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    [self.startGameButton setBackgroundImage:buttonImageSelected forState:UIControlStateHighlighted];
    [self.scene.view addSubview:self.startGameButton];
    
    [self.startGameButton addTarget:self action:@selector(moveToGame) forControlEvents:UIControlEventTouchUpInside];
    
    self.highScoresButton= [UIButton buttonWithType:UIButtonTypeCustom];
    self.highScoresButton.frame = CGRectMake(CGRectGetMidX(self.frame)-105, CGRectGetMaxY(self.frame)-295, 210, 50);
    UIImage* buttonImageNormal1 = [UIImage imageNamed:@"highScoresButton"];
    UIImage* buttonImageSelected1 = [UIImage imageNamed:@"highScoresButton--selected"];
    [self.highScoresButton setBackgroundImage:buttonImageNormal1 forState:UIControlStateNormal];
    [self.highScoresButton setBackgroundImage:buttonImageSelected1 forState:UIControlStateHighlighted];
    [self.scene.view addSubview:self.highScoresButton];

     [self.highScoresButton addTarget:self action:@selector(moveToHighScores) forControlEvents:UIControlEventTouchUpInside];
    
    self.settingsButton= [UIButton buttonWithType:UIButtonTypeCustom];
    self.settingsButton.frame = CGRectMake(CGRectGetMidX(self.frame)-105, CGRectGetMaxY(self.frame) -230, 210, 50);
    UIImage* buttonImageNormal2 = [UIImage imageNamed:@"settingsButton"];
    UIImage* buttonImageSelected2 = [UIImage imageNamed:@"settingsButton--selected"];
    [self.settingsButton setBackgroundImage:buttonImageNormal2 forState:UIControlStateNormal];
    [self.settingsButton setBackgroundImage:buttonImageSelected2 forState:UIControlStateHighlighted];
    [self.scene.view addSubview:self.settingsButton];
    
    [self.settingsButton addTarget:self action:@selector(moveToSettings) forControlEvents:UIControlEventTouchUpInside];

    
    self.howToPlayButton= [UIButton buttonWithType:UIButtonTypeCustom];
    self.howToPlayButton.frame = CGRectMake(CGRectGetMidX(self.frame)-105, CGRectGetMaxY(self.frame) -165, 210, 50);
    UIImage* buttonImageNormal3 = [UIImage imageNamed:@"howToPlayButton"];
    UIImage* buttonImageSelected3 = [UIImage imageNamed:@"howToPlayButton--selected"];
    [self.howToPlayButton setBackgroundImage:buttonImageNormal3 forState:UIControlStateNormal];
    [self.howToPlayButton setBackgroundImage:buttonImageSelected3 forState:UIControlStateHighlighted];
    [self.scene.view addSubview:self.howToPlayButton];

    [self.howToPlayButton addTarget:self action:@selector(moveToHowToPlay) forControlEvents:UIControlEventTouchUpInside];
}


#pragma Actions Methods

-(void) moveToGame {
    
    ALMyScene* game = [[ALMyScene alloc] initWithSize:CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
    
    SKTransition* transition = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.startGameButton removeFromSuperview];
    [self.highScoresButton removeFromSuperview];
    [self.settingsButton removeFromSuperview];
    [self.howToPlayButton removeFromSuperview];
    [self.scene.view presentScene:game transition:transition];
}


-(void) moveToSettings {
    
    ALSettingsScene* settings = [[ALSettingsScene alloc] initWithSize:CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
    
    [self.startGameButton removeFromSuperview];
    [self.highScoresButton removeFromSuperview];
    [self.settingsButton removeFromSuperview];
    [self.howToPlayButton removeFromSuperview];
    
    SKTransition* transition = [SKTransition crossFadeWithDuration:0.5];
    [self.scene.view presentScene:settings transition:transition];
    
}


-(void) moveToHighScores {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ALHighScoresTableViewController *highScores = [storyboard instantiateViewControllerWithIdentifier:@"HighScores"];
    UIViewController *vc = self.view.window.rootViewController;
    [vc presentViewController:highScores animated:YES completion:nil];

    
}


-(void) moveToHowToPlay {
    
    ALHowToPlayScene* rules = [[ALHowToPlayScene alloc] initWithSize:CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
    
    [self.startGameButton removeFromSuperview];
    [self.highScoresButton removeFromSuperview];
    [self.settingsButton removeFromSuperview];
    [self.howToPlayButton removeFromSuperview];
    
    SKTransition* transition = [SKTransition crossFadeWithDuration:0.5];
    [self.scene.view presentScene:rules transition:transition];
    
    
}

@end




