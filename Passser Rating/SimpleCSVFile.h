//
//  SimpleCSVFile.h
//  Passer Rating
//
//  Created by Xcode User on 4/22/10.
//  Copyright 2010 Frederic F. Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class	SimpleCSVFile;

extern NSString * const		WT9TErrorDomain;

enum _CSVErrors {
	errCSVBadFormatLine = -1,
	errEmptyCSVFile = -2
};

/// \c NSError* \c userInfo dictionary key for the
/// line on which an error was detected. (\c NSNumber)
extern NSString * const		kCSVErrorLineKey;
/// \c NSError* \c userInfo dictionary key for the
/// number of fields in the header line. (\c NSNumber)
extern NSString * const		kCSVExpectedFieldsKey;
/// \c NSError* \c userInfo dictionary key for the
/// number of fields found in a record line. (\c NSNumber)
extern NSString * const		kCSVActualFieldsKey;

/**
 Delegate for SimpleCSVFile.
 A SimpleCSVFileDelegate receives a dictionary from 
 -[SimpleCSVFile run:] for each line it parses after the header.
 The dictionary will be keyed on the names found in the header
 line, and the values will be drawn from the fields in the 
 corresponding positions.
 */
@protocol SimpleCSVDelegate <NSObject>

/**
 Receive key-value data from a line in a CSV file.
 
 This method is called once for every line in the file
 after the first by -[SimpleCSVFie run:]. The receiver 
 can stop parsing by returning \c NO. If it does, and
 \p error is not \c NULL, you must return \c nil or an
 \c NSError* object in \p *error.
 
 The dictionary will be keyed on the names found in the header
 line, and the values will be drawn from the fields in the 
 corresponding positions.

 @param     file    The SimpleCSVFile object doing the parsing.
 @param     values  A dictionary of strings representing the 
                    field values in the record line, keyed by
                    the field names supplied in the header line.
 @param[out] error  A pointer to an \c NSError object pointer.
                    May be \c NULL. If it is not, and the receiver
                    returns NO, this \e must be set to a valid
                    \c NSError object pointer, or at least to 
                    \c nil.
 @return    \c YES if parsing may continue, or \c NO if it may not.
            If \c NO, be sure to fill \p error.
 */
- (BOOL) csvFile: (SimpleCSVFile *) file
	  readValues: (NSDictionary *) values
		   error: (NSError **) error;

@end

/**
 Parser for simple CSV files.
 SimpleCSVFile will open a file and attempt to extract key-value data from it.
 It is expected that the first line will include keys that identify the fields
 in the data stream.
 
 @warning This is not a general CSV parser. 
 In particular, it does not handle quotes, embedded commas, or escaping.
 */

@interface SimpleCSVFile : NSObject {
}

/**
 Initialize with a path to a CSV file.
 
 @param aPath   A string containing an absolute or relative path to the input file.
 @return The receiver.
 */
- (id) initWithPath: (NSString *) aPath;

/**
 Parse the CSV file.
 Loops through the lines of the input file, interpreting the first line
 as unique keys for the data fields contained in the remaining lines.
 
 The keys and values for each line are gathered into an NSDictionary,
 which is presented line-by-line to the delegate object.
 
 It is an error for the file to have a line with a different number of
 fields than specified in the header line.
 
 @param[out] error  A pointer to an \c NSError object pointer, or nil.
                    If non-nil, and an error occurs (signified by a 
                    return value of \c NO), *error will describe the
                    problem.
 @return    Whether parsing succeeded. If \c NO, and an \c NSError** parameter
            was supplied, \p *error will describe the problem.
 
 @see       SimpleCSVDelegate
 */
- (BOOL) run: (NSError **) error;

/// The path to the CSV file.
/// Setting this property has no effect after run: is called.
@property(nonatomic, copy)		NSString *              path;
/// An array of NSStrings which are the header names.
@property(nonatomic, readonly, retain)	NSArray *		headers;
/// The delegate to which record dictionaries are presented.
@property(nonatomic, assign)	id <SimpleCSVDelegate>  delegate;
/**
 A managed-object context, for the use of the client.
 SimpleCSVFile makes no use of this property. It is provided as
 a convenience to the caller, so it can associate the records
 with a managed-object context.
 */
@property(strong) NSManagedObjectContext *              moc;

@end
