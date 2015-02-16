

#import "CollectionViewController.h"
#import "Cell.h"
#import "PhotosController.h"
#import "ViewController.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

#define REUSEABLE_CELL_IDENTITY @"CELL"

@interface CollectionViewController () {
    UIImagePickerController *imagePicker;
    UIImage *takenImage;
    UIImage *processedImage;
}

@property (strong, nonatomic) IBOutlet UIImageView *resultImageView;

@end

@implementation CollectionViewController
@synthesize items2;
@synthesize pictureNames;
@synthesize resultImageView;
@synthesize albumViewController;
@synthesize datas;
@synthesize pictureIds;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.toolbarHidden=NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.toolbarHidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor grayColor];
    UIBarButtonItem *it1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *its2=[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addButtonClicked:)];
    its2.tintColor=[UIColor blackColor];
    its2.width=80;
    UIBarButtonItem *its3=[[UIBarButtonItem alloc]initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteButtonClicked:)];
    its3.tintColor=[UIColor redColor];
    its3.width=80;
    self.toolbarItems=[NSArray arrayWithObjects:its2,it1,its3, nil];
    
    NSString *albumName=[self.albumViewController.albumNames objectAtIndex:self.selectedAlbumTableViewIndex];
    self.title=[NSString stringWithFormat:@"Pictures of %@",albumName];
    self.navigationController.title=@"";
    self.navigationController.toolbar.translucent=YES;
    //self.navigationController.toolbar.backgroundColor=[UIColor blackColor];
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:REUSEABLE_CELL_IDENTITY];
    
    items2=[[NSMutableArray alloc]init];
    pictureNames=[[NSMutableArray alloc]init];
    datas=[[NSMutableArray alloc]init];
    pictureIds=[[NSMutableArray alloc]init];
    
    NSString *album_id=[self.albumViewController.albumIds objectAtIndex:self.selectedAlbumTableViewIndex];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.222/alan/picture_mng.php"]];
    [request setPostValue:@"index" forKey:@"action"];
    [request setPostValue:album_id forKey:@"album_id"];
    [request setDelegate:self];
    [request startAsynchronous];
}
-(void)clickaction:(id)sender{

    UIBarButtonItem *it1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *its2=[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addButtonClicked:)];
    its2.tintColor=[UIColor blackColor];
    its2.width=80;
    UIBarButtonItem *its3=[[UIBarButtonItem alloc]initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteButtonClicked:)];
    its3.tintColor=[UIColor redColor];
    its3.width=80;
    self.toolbarItems=[NSArray arrayWithObjects:its2,it1,its3, nil];
//    UIBarButtonItem  *clickbuttonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(clickcancel:)];
//    clickbuttonItem.tintColor=[UIColor blueColor];
//    self.navigationItem.rightBarButtonItem=clickbuttonItem;
}
//-(void)clickbutton:(id)sender{
//    NSMutableArray *array=[NSMutableArray arrayWithCapacity:21];
//    UIImage *img=nil;
//    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 375)];
//    for (int i=0; i<21; i++) {
//        img=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",i]];
//        [array addObject:img];
//        imageview.animationImages=array;
//        imageview.animationDuration=21;
//    }
//    [self.view addSubview:imageview];
//    if (imageview.isAnimating) {
//        [imageview stopAnimating];
//    }
//    else{
//        [imageview startAnimating];
//    }
//}
-(void)clickcancel:(id)sender {
    self.navigationItem.rightBarButtonItem=nil;
    [self viewDidLoad];
}
-(void)deleteButtonClicked:(id)sender{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Photo" otherButtonTitles:nil, nil];
    [action showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != actionSheet.cancelButtonIndex) {
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.222/alan/picture_mng.php"]];
        [request setPostValue:[self.albumViewController.albumIds objectAtIndex:self.selectedAlbumTableViewIndex] forKey:@"album_id"];
        [request setPostValue:@"alldelete" forKey:@"action"];
        [request setDelegate:self];
        [request startAsynchronous];
    } else
        [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)addButtonClicked:(id)sender{
    imagePicker = [UIImagePickerController new];
    [imagePicker setDelegate:self];
    [imagePicker setAllowsEditing:YES];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Take a photo or choose existing, and use the control to center the announce" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take photo", @"Choose Existing", nil];
        [actionSheet showInView:self.view];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    CGRect croppedRect=[[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
    UIImage *original=[info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *rotatedCorrectly;
    
    if (original.imageOrientation!=UIImageOrientationUp)
        rotatedCorrectly = [original rotate:original.imageOrientation];
    else
        rotatedCorrectly = original;
    
    CGImageRef ref= CGImageCreateWithImageInRect(rotatedCorrectly.CGImage, croppedRect);
    takenImage= [UIImage imageWithCGImage:ref];
    [self.resultImageView setImage:takenImage];
    processedImage= takenImage;
    NSMutableArray * temp = [[NSMutableArray alloc] init];
    [temp addObject:processedImage];
    
   // NSIndexPath *indexpath=[NSIndexPath indexPathForRow:[items2 count]-1 inSection:0];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"New Photo" message:@"Enter a name for this Photo" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        UITextField *txt=[alertView textFieldAtIndex:0];
        NSString *pictureName=txt.text;
        if ([pictureName isEqualToString:@""])
            pictureName=@"New Picture";
        [pictureNames addObject:pictureName];
        
        NSString *album_index = [self.albumViewController.albumIds objectAtIndex:self.selectedAlbumTableViewIndex];
        NSString *file_name = [NSString stringWithFormat:@"default.png",album_index,[items2 count]-1];
     	
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.222/alan/picture_mng.php"]];
        NSData* img_data = UIImageJPEGRepresentation(processedImage, 50);
        [request setData:img_data withFileName:file_name andContentType:@"image/png" forKey:@"image"];
        [request setPostValue:@"insert" forKey:@"action"];
        [request setPostValue:pictureName forKey:@"name"];
        [request setPostValue:album_index forKey:@"album_id"];
        [request setPostValue:[self.albumViewController.albumIds objectAtIndex:self.selectedAlbumTableViewIndex] forKey:@"album_id"];
        [request setDelegate:self];
        [request startAsynchronous];
     }

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return [items2 count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:REUSEABLE_CELL_IDENTITY forIndexPath:indexPath];
    NSString *fileName = [items2 objectAtIndex:indexPath.row];
    NSString *imageURL = [NSString stringWithFormat:@"http://192.168.1.222/alan/pictures/%@",fileName];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    cell.imageview.image=image;
    cell.bounds=CGRectMake(0, 0, 90, 90);
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotosController *photo=[[PhotosController alloc]initWithNibName:@"PhotosController" bundle:nil];
    photo.items3=items2;
    photo.selectedPictureIndex=indexPath.row;
    photo.photoCollectionViewController=self;
    [self.navigationController pushViewController:photo animated:YES];
    //PhotosController *pc=[[PhotosController alloc] initWithNibName:@"" bundle:nil];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    if (request.responseStatusCode == 200) {
        NSString *str =[request responseString];
        //NSLog(@"%@",str);
        if ([str rangeOfString:@"insert"].location != NSNotFound){
            NSDictionary* dict = [str JSONValue];
            datas = (NSMutableArray*)dict;
            [items2 addObject:[datas valueForKey:@"new_picture"]];
            [pictureIds addObject:[datas valueForKey:@"maxid"]];
            [self.collectionView reloadData];
            
            NSLog(@"%@",[datas valueForKey:@"action"]);
        }
        else if ([str rangeOfString:@"alldelete"].location != NSNotFound){
            NSDictionary* dict = [str JSONValue];
            datas = (NSMutableArray*)dict;
            
            [items2 removeAllObjects];
            [pictureNames removeAllObjects];
            [pictureIds removeAllObjects];
            
            [self.collectionView reloadData];
            NSLog(@"%@",[datas valueForKey:@"action"]);
        }
        else {
            NSDictionary* dict = [str JSONValue];
            datas = (NSMutableArray*)dict;
            
            int n=0;
            NSMutableArray *values;
            while (n < [datas count]) {
                values = [datas objectAtIndex:n];
                [items2 addObject:[values valueForKey:@"filename"]];
                [pictureNames addObject:[values valueForKey:@"name"]];
                [pictureIds addObject:[values valueForKey:@"id"]];
                n++;
            }
            [self.collectionView reloadData];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection error", nil) message:NSLocalizedString(@"messageConnectionError", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection error", nil) message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}

@end
