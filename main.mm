


#define joinS(x, y) [x stringByAppendingString:y]

//making a category on NSDictionary to check if it contains a key

@implementation NSDictionary (containsOb)

- (BOOL)containsKey:(NSString *)key {
	BOOL retVal = 0;
	NSArray *allKeys = [self allKeys];
	retVal = [allKeys containsObject:key];
	return retVal;
}

@end







int main(int argc, char **argv, char **envp) {
	
	
	
	@autoreleasepool{
		
		NSFileManager *fileMan = [[NSFileManager alloc] init];
		
		NSMutableDictionary<NSString*, NSNumber*> *extDict = [[NSMutableDictionary alloc] init];
		// getting the current working directory
		NSString *absCwd = [[fileMan currentDirectoryPath] stringByResolvingSymlinksInPath];
		//joining the current working directory with a fowroard slash so the file manager can read it as a diretory
		NSString *myPath = joinS(absCwd, @"/");
		//printf("\nsearching :%s \n", [myPath UTF8String]);
		
		//check if there a second argument
		if (argc > 1) {
			// convert the second argument into NSString from c string
			NSString *dirArg = [NSString stringWithUTF8String:argv[1]];
			//join the current Path with the second argument
			dirArg = joinS(myPath, dirArg);
			//a bool to check if the path is a dir
			BOOL isDir;
			// self explantory assigns the bool for isDir
			if ([fileMan fileExistsAtPath:dirArg isDirectory:&isDir]) {
				if (isDir) {
					myPath = dirArg;
				}else {
					printf("\nthis is not a directory \nsearching the current directory");
				}
				// if fileman
			}else {
				printf("\nDirectory does not exsist \nSearching currnet path :%s", [myPath UTF8String]);
			}
		//if argc > 1
		}else {
			printf("\n%s directoryToSearch \n returns all the file exstensions in the specified path \n", argv[0]);
			
			printf("\n searching the currnet path :%s \n", [myPath UTF8String]);
		}
		
		
		
		
		
		
		//printf("%s \n", [myPath UTF8String]);
		//checking if the last charchter in my path is a forward slash / if not we add it to it 
		// because for some weird reason NSFileManger requires that to identify a path as a directory
		if (![[myPath substringFromIndex:[myPath length] - 1] isEqualToString:@"/"]) {
			myPath = joinS(myPath, @"/");
		}
		
		
		
		
		// files in directory
		NSMutableArray *files = [[NSMutableArray alloc] init];
		
		NSError *dirErr;
		//get the contents of myPath
		NSArray *contentsOfDir = [fileMan contentsOfDirectoryAtPath:myPath error:&dirErr];
		//if there is no error
		if (!dirErr) {
			for (NSString *oName in contentsOfDir) {
				BOOL isDirr;
				
				if ([fileMan fileExistsAtPath:joinS(myPath, oName) isDirectory:&isDirr]) {
					if (!isDirr) {
						// if the file exsist and is not a directory 
						[files addObject:oName];
						
					}
				}
			}
		}else {
			NSLog(@"%@", [dirErr localizedDescription]);
		}
		
		//looping through our files to get the exstensions
		for (NSString* file in files) {
			
			static NSString *ext;
			//getting the path extension for the file
			ext = [file pathExtension];
			//making it lower case 
			//since some files have an upercased extensions 
			//that is equal to the lower cased ones
			//e.g (.mm, .Mm, .MM) becomes .mm
			ext = [ext lowercaseString];
			if ([ext isEqualToString:@""] || !ext) {
				//if there is no extension add the file name 
				//e.g ( .bashrc, Makefile, DEBAIN)
				ext = file;
			}
			//if the dictionary already contains the extension 
			//increment its int value by 1
			if ([extDict containsKey:ext]) {
				int oldVal = [extDict[ext] intValue];
				oldVal +=1;
				[extDict setObject:@(oldVal) forKey:ext];
			}else {
				//else set 1 (as NSNumber) for the key since it doesn't exsist
				[extDict setObject:@(1) forKey:ext];
			}
			
		}
		//print all the extesinons
		printf("\nFiles \n{");
		for (NSString *key in [extDict allKeys]) {
			printf("\n%s:%d", [key UTF8String], [extDict[key] intValue]);
		}
		printf("\n} \n");
		
	}
	
	
	
	return 0;
}

// vim:ft=objc
