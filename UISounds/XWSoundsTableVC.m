//
//  XWSoundsTableVC.m
//  UISounds
//
//  Created by qway on 16/8/9.
//  Copyright © 2016年 qway. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "XWSoundsTableVC.h"

@interface XWSoundsTableVC ()

@property(nonatomic, copy)NSArray * files;

@end

@implementation XWSoundsTableVC

- (NSArray*) allFilesAtPath:(NSString*) dirString {
    NSLog(@"%@", dirString);
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirString error:nil];
    
    for (NSString* fileName in tempArray) {
        NSLog(@"fileName：%@", fileName);
        
        NSString* fullPath = [dirString stringByAppendingPathComponent:fileName];
        BOOL flag = YES;
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            
            if (!flag) {
                [array addObject:fileName];
            }
        }
    }
    
    return array;
}

//当音频播放完毕会调用这个函数
static void soundCompleteCallback(SystemSoundID soundID,void* sample){
    /*播放全部结束，因此释放所有资源 */
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    AudioServicesDisposeSystemSoundID(soundID);
    AudioServicesRemoveSystemSoundCompletion(soundID);
    //    CFRelease(&soundID);
    CFRunLoopStop(CFRunLoopGetCurrent());
}

-(void)playSystemSoundWithName:(NSString *)soundNameType
{
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@", soundNameType];
//    NSString *path = soundNameType;
    if (nil==path) {
        return;
    }
    SystemSoundID soundID;//系统声音的id 取值范围为：1000-2000
    if (path) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"Error occurred assigning system sound!");
            return;
        }
    }
    AudioServicesPlaySystemSound(soundID);
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);//带震动
    //    AudioServicesDisposeSystemSoundID(soundID);
    //    AudioServicesRemoveSystemSoundCompletion(soundID);
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds"];
    _files=[NSArray arrayWithArray:[self allFilesAtPath:path]];
//    NSLog(@"files:%@", [self allFilesAtPath:path]);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds"];
//    _files=[NSArray arrayWithArray:[self allFilesAtPath:path]];
    
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self playSystemSoundWithName:[NSString stringWithFormat:@"%@", _files[indexPath.row]]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"_files.count==%lu", (unsigned long)_files.count);
    return _files.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UISounds" forIndexPath:indexPath];
    cell.textLabel.text=[NSString stringWithFormat:@"%@", _files[indexPath.row]];
    // Configure the cell...
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
