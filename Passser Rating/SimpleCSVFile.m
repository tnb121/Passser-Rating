//
//  SimpleCSVFile.m
//  Passer Rating
//
//  Created by Xcode User on 4/22/10.
//  Copyright 2010 Frederic F. Anderson. All rights reserved.
//

#import "SimpleCSVFile.h"

NSString * const	WT9TErrorDomain		= @"com.wt9t.err";

NSString * const		kCSVErrorLineKey = @"kCSVErrorLineKey";
NSString * const		kCSVExpectedFieldsKey = @"kCSVExpectedFieldsKey";
NSString * const		kCSVActualFieldsKey = @"kCSVActualFieldsKey";

@interface SimpleCSVFile ()
@property(nonatomic, readwrite, retain) NSArray *		headers;
@end

@implementation SimpleCSVFile

@synthesize path;
@synthesize headers;
@synthesize delegate;
@synthesize moc;

- (id) initWithPath: (NSString *) aPath
{
	if (self = [super init]) {
		path = [aPath copy];
	}
	return self;
}

- (BOOL) run: (NSError **) error
{
	if (error)
        *error = nil;
	
	NSString *	contents = [NSString stringWithContentsOfFile: self.path
													encoding: NSUTF8StringEncoding
													   error: error];
	if (! contents)
		return NO;	
	
	NSArray *	lines = [contents componentsSeparatedByCharactersInSet: 
						 [NSCharacterSet newlineCharacterSet]];
	int			lineCount = 0;
	
	for (NSString * line in lines) {
		lineCount++;
		
		//	Decompose the line by commas. Real CSV can't break fields this
		//	way, but this is a baby-simple parser.
		NSArray *		fields = [line componentsSeparatedByString: @","];
		
		if (! self.headers) {
			//	The first line is a header supplying the field keys.
			self.headers = fields;
		}
		else {
			//	Subsequent lines contain records, with field values.
            //  Skip blank lines.
			if (fields.count <= 1)
				continue;
			
			if (fields.count != self.headers.count) {
				//	The only error this parser catches:
				//	The record does not have the same number of fields as
				//	specified in the header. Report the file path, line number,
				//	expected, and actual field counts. 
				if (error) {
					NSString *		localizedDescription = 
                    [NSString stringWithFormat:
                     @"%@:%d: Expected %d fields, got %d.",
                     self.path, lineCount, self.headers.count, fields.count];
                    
					NSDictionary *	userInfo =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSNumber numberWithInt: lineCount], kCSVErrorLineKey,
                     [NSNumber numberWithInt: self.headers.count], kCSVExpectedFieldsKey,
                     [NSNumber numberWithInt: fields.count], kCSVActualFieldsKey,
                     self.path, NSFilePathErrorKey,
                     localizedDescription, NSLocalizedDescriptionKey,
                     nil];
					
					*error = [NSError errorWithDomain: WT9TErrorDomain
												 code: errCSVBadFormatLine
											 userInfo: userInfo];
				}
				return NO;				
			}
			//	Compose a dictionary of the fields, keyed by the headers.
			NSDictionary *	values = 
						[NSDictionary dictionaryWithObjects: fields
													forKeys: self.headers];
			//	Present the record to the delegate.
			BOOL	accepted = [self.delegate csvFile: self
										readValues: values
											 error: error];
			//	If the delegate refuses (or otherwise wants parsing to stop),
			//	return failure (more or less).
			if (! accepted)
				return NO;
		}        
	}
	
	return YES;	
}

- (void) dealloc
{
	[path release];
	[headers release];
	[super dealloc];
}

@end
