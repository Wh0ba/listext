


#define joinS(x, y) [x stringByAppendingString:y]



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
		NSString *absCwd = [[fileMan currentDirectoryPath] stringByResolvingSymlinksInPath];
		
		NSString *myPath = joinS(absCwd, @"/");
		//printf("\nsearching :%s \n", [myPath UTF8String]);
		
		if (argc > 1) {
			NSString *dirArg = [NSString stringWithUTF8String:argv[1]];
			dirArg = joinS(myPath, dirArg);
			BOOL isDir;
			
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
		if (![[myPath substringFromIndex:[myPath length] - 1] isEqualToString:@"/"]) {
			myPath = joinS(myPath, @"/");
		}
		
		
		
		
		
		NSMutableArray *files = [[NSMutableArray alloc] init];
		
		NSError *dirErr;
		NSArray *contentsOfDir = [fileMan contentsOfDirectoryAtPath:myPath error:&dirErr];
		if (!dirErr) {
			for (NSString *oName in contentsOfDir) {
				BOOL isDirr;
				
				if ([fileMan fileExistsAtPath:joinS(myPath, oName) isDirectory:&isDirr]) {
					if (!isDirr) {
						
						[files addObject:oName];
						
					}
				}
			}
		}else {
			HBLogDebug(@"%@", [dirErr localizedDescription]);
		}
		
		
		for (NSString* file in files) {
			
			static NSString *ext;
			
			ext = [file pathExtension];
			ext = [ext lowercaseString];
			if ([ext isEqualToString:@""] || !ext) {
				ext = file;
			}
			
			if ([extDict containsKey:ext]) {
				int oldVal = [extDict[ext] intValue];
				oldVal +=1;
				[extDict setObject:@(oldVal) forKey:ext];
			}else {
				[extDict setObject:@(1) forKey:ext];
			}
			
		}
		printf("\nFiles {");
		for (NSString *key in [extDict allKeys]) {
			printf("\n%s:%d", [key UTF8String], [extDict[key] intValue]);
		}
		printf("\n } \n");
		
	}
	
	
	
	return 0;
}

// vim:ft=objc
