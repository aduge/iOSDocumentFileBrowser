//
//  ViewController.m
//  iOSDocumentFileBrowser
//
//  Created by BinqianDu on 8/13/15.
//  Copyright (c) 2015 Binqian Du. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;

@end

@implementation ViewController
NSMutableDictionary* tableDataDic;
NSMutableArray* titleArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Do any additional setup after loading the view, typically from a nib.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];

    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    

    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSString *file in fileList)
    {
        [array addObject:file];
    }
    NSLog(@"Every Thing in the dir:%@",fileList);
    
    [self processDataBeforeReloadData:array];
}


- (void)processDataBeforeReloadData:(NSMutableArray*)array
{
    titleArr = [[NSMutableArray alloc]init];
    tableDataDic = [[NSMutableDictionary alloc]init];
    
    
    for (int i = 0; i<array.count; i++) {
        NSString *urlString = [NSString stringWithFormat:@"%@",[array objectAtIndex:i]];
        
        NSString *extension = [urlString pathExtension];
        if (![titleArr containsObject:extension]) {
            [titleArr addObject:extension];
            
            NSMutableArray * temp_Arr =[[NSMutableArray alloc]initWithObjects:urlString, nil];
            [tableDataDic setObject:temp_Arr forKey:extension];
            
            
        }else{
            
            NSMutableArray *temp_Arr = [tableDataDic objectForKey:extension];
            [temp_Arr addObject:urlString];
            
            [tableDataDic setObject:temp_Arr forKey:extension];
            
        }
        
    }
    
    [self.tableView reloadData];
    
}


#pragma tableviewDatasource&&delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return titleArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellName = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellName];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSURL *fileURL= nil;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    
    NSString* title = [titleArr objectAtIndex:indexPath.section];
    
    NSString *path = [documentDir stringByAppendingPathComponent:[[tableDataDic objectForKey:title] objectAtIndex:indexPath.row]];
    fileURL = [NSURL fileURLWithPath:path];
    
    
    [self setupDocumentControllerWithURL:fileURL];
    cell.textLabel.text = [[tableDataDic objectForKey:title] objectAtIndex:indexPath.row];
    NSInteger iconCount = [self.docInteractionController.icons count];
    if (iconCount > 0)
    {
        cell.imageView.image = [self.docInteractionController.icons objectAtIndex:iconCount - 1];
    }
    
    NSString *fileURLString = [self.docInteractionController.URL path];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileURLString error:nil];
    NSInteger fileSize = [[fileAttributes objectForKey:NSFileSize] intValue];
    NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:fileSize
                                                           countStyle:NSByteCountFormatterCountStyleFile];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", fileSizeStr, self.docInteractionController.UTI];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* title = [titleArr objectAtIndex:section];
    return [[tableDataDic objectForKey:title] count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;
    
    
    previewController.currentPreviewItemIndex = indexPath.row;
    [[self navigationController] pushViewController:previewController animated:YES];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return titleArr;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [titleArr objectAtIndex:section];
}





#pragma mark - UIDocumentInteractionControllerDelegate

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}





#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    return 1;
}



// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    NSURL *fileURL = nil;
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    
    NSString* title = [titleArr objectAtIndex:selectedIndexPath.section];
    NSString *path = [documentDir stringByAppendingPathComponent:[[tableDataDic objectForKey:title] objectAtIndex:selectedIndexPath.row]];
    fileURL = [NSURL fileURLWithPath:path];
    return fileURL;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    if (self.docInteractionController == nil)
    {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }
    else
    {
        self.docInteractionController.URL = url;
    }
}
@end
