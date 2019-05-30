//
//  TableViewController.m
//  MessageDetect
//
//  Created by Jiao Liu on 5/29/19.
//  Copyright © 2019 ChangHong. All rights reserved.
//

#import "TableViewController.h"
#import "SMSClassifier.h"

@interface TableViewController ()
{
    NSMutableArray *data;
    SMSClassifier *classifier;
}

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    classifier = [[SMSClassifier alloc] init];
    NSArray *initD = @[@"Did you hear about the new \"Divorce Barbie\"? It comes with all of Ken's stuff!",
             @"100 dating service cal;l 09064012103 box334sk38ch",
             @"Hello, I'm james",
             @"Even my brother is not like to speak with me. They treat me like aids patent.",
             @"HOT LIVE FANTASIES call now 08707509020 Just 20p per min NTT Ltd, PO Box 1327 Croydon CR9 5WB 0870..k",
             @"Ok...",
             @"Yeah!!",
             @"Oh my God.",
             @"Our brand new mobile music service is now live. The free music player will arrive shortly. Just install on your phone to browse content from the top artists."];
    data = [NSMutableArray arrayWithArray:initD];
    self.tableView.allowsSelection = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Message" forIndexPath:indexPath];
    
    cell.textLabel.text = data[indexPath.row];
    NSString *type = [classifier predictionFromText:data[indexPath.row] error:nil].label;
    if ([type isEqualToString:@"spam"]) {
        cell.textLabel.textColor = [UIColor redColor];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    else
    {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (IBAction)AddMessage:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Message" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"message";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *newMsg = alert.textFields.firstObject.text;
        if (newMsg.length != 0) {
            [self->data insertObject:alert.textFields.firstObject.text atIndex:0];
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
