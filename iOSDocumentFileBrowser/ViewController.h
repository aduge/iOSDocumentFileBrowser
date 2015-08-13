//
//  ViewController.h
//  iOSDocumentFileBrowser
//
//  Created by BinqianDu on 8/13/15.
//  Copyright (c) 2015 Binqian Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIDocumentInteractionControllerDelegate>



@end

