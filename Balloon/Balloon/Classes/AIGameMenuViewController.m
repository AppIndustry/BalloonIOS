//
//  AIGameMenuViewController.m
//  BalloonPopper
//
//  Created by Mun Fai Leong on 3/8/15.
//  Copyright (c) 2015 myAppIndustry. All rights reserved.
//

#import "AIGameMenuViewController.h"
#import "AIGameSceneViewController.h"

@interface AIGameMenuViewController ()
{
    BOOL isGameModeFull;
}
@end

@implementation AIGameMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"NextToGame"])
    {
        AIGameSceneViewController *gamescene = [segue destinationViewController];
        gamescene.isGameModeFull = isGameModeFull;
    }
}


- (IBAction)SinglePlayerMode:(id)sender
{
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"Select Game Play" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Full Game Play", @"Short Game Play", nil];
    action.tag = 1;
    [action showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        if (buttonIndex == 0)
        {
            //NSLog(@"long");
            isGameModeFull = YES;
            [self performSegueWithIdentifier:@"NextToGame" sender:self];
        }
        else if (buttonIndex == 1)
        {
            //NSLog(@"short");
            isGameModeFull = NO;
            [self performSegueWithIdentifier:@"NextToGame" sender:self];
        }
    }
}

@end
