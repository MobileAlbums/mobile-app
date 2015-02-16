

#import "PhotosController.h"
#import "CollectionViewController.h"
#import "ViewController.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@interface PhotosController ()

@end

@implementation PhotosController
@synthesize photoCollectionViewController;
@synthesize selectedPictureIndex;
@synthesize items3;
@synthesize datas;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor=[UIColor grayColor];
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonClicked:)];
    UIBarButtonItem *itms1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(filterButtonClicked:)];
    UIBarButtonItem *itms2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item3=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteButtonClicked:)];
    NSArray *items=[NSArray arrayWithObjects:item1,itms1,item3, nil];
    self.toolbarItems=items;
    
    label.text=[NSString stringWithFormat:@"%@",[self.photoCollectionViewController.pictureNames objectAtIndex:self.selectedPictureIndex]];
    datas = [[NSMutableArray alloc] init];
    //items3 =[[NSMutableArray alloc] init];
    NSString *fileName = [items3 objectAtIndex:self.selectedPictureIndex];
    NSString *imageURL = [NSString stringWithFormat:@"http://192.168.1.222/alan/pictures/%@",fileName];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    imageview.image=image;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.toolbarHidden=NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.toolbarHidden=YES;
}
//-(void)filterButtonClicked:(id)sender{
//    if (imageview.isAnimating) {
//        [imageview stopAnimating];
//    }
//    else{
//        [imageview startAnimating];
//    }
//
//}

-(void)deleteButtonClicked:(id)sender{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Photo" otherButtonTitles:nil, nil];
    [action showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSString *id = [self.photoCollectionViewController.pictureIds objectAtIndex:self.selectedPictureIndex];
         ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.222/alan/picture_mng.php"]];
        [request setPostValue:id forKey:@"id"];
        [request setPostValue:@"delete" forKey:@"action"];
        [request setDelegate:self];
        [request startAsynchronous];
        //self.title=[NSString stringWithFormat:@"%iof%i",s+1,s+1];
    }
    else if (buttonIndex==1){
       
    }
}
-(void)shareButtonClicked:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Change Photo Name" message:@"Enter a name for this Photo" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        UITextField *txt=[alertView textFieldAtIndex:0];
        picturename=txt.text;
        if ([picturename isEqualToString:@""])
            picturename=@"New Album";
        
        NSString *id = [self.photoCollectionViewController.pictureIds objectAtIndex:self.selectedPictureIndex];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.222/alan/picture_mng.php"]];
        [request setPostValue:id forKey:@"id"];
        [request setPostValue:@"update" forKey:@"action"];
        [request setPostValue:picturename forKey:@"name"];
        [request setDelegate:self];
        [request startAsynchronous];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    if (request.responseStatusCode == 200) {
        NSString *str =[request responseString];
        //NSLog(@"%@",str);
        if ([str rangeOfString:@"delete"].location != NSNotFound){
            NSDictionary* dict = [str JSONValue];
            datas = (NSMutableArray*)dict;
            
            [photoCollectionViewController.items2 removeObjectAtIndex:self.selectedPictureIndex];
            [photoCollectionViewController.pictureIds removeObject:self.self];
            [photoCollectionViewController.pictureNames removeObjectAtIndex:self.selectedPictureIndex];
            imageview.image=nil;
            label.text=@"";
            [photoCollectionViewController.collectionView reloadData];
            
            NSLog(@"%@",[datas valueForKey:@"action"]);
        }
        else if ([str rangeOfString:@"update"].location != NSNotFound){
            NSDictionary* dict = [str JSONValue];
            datas = (NSMutableArray*)dict;
            
            //self.title=[NSString stringWithFormat:@"%@",picturename];
            label.text = picturename;
            [self.photoCollectionViewController.pictureNames setObject:picturename atIndexedSubscript:selectedPictureIndex];
            NSLog(@"%@",[datas valueForKey:@"action"]);
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection error", nil) message:NSLocalizedString(@"messageConnectionError", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

@end




