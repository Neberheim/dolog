#!/usr/bin/env xcrun swift

/* *********************************
	 DOLOG Script for Alfred App
   ********************************* */


// requires Swift 3.0
// might work with Swift 2.0 but is untested
// Will not work with Swift 1.0


//-- get parameter input

var argument = ""
#if swift(>=3.0)
	if CommandLine.arguments.count > 1 {
		argument = CommandLine.arguments[1]
	}
#elseif swift(>=2.0)
	if Process.arguments.count > 1 {
		argument = Process.arguments[1]
	}
#elseif swift(>=1.0)
	print("Unsupported version of Swift (<= 2.0) please update to Swift 2.0 or above (Swift 3 supported)!")
	break
#endif

import Foundation

// MARK: - Properties

// task will hold the completed task passed in

var task  = ""

// The result of the script that will be passed to the CLI, we initialize it with the
// Day One CLI command setting the journal to 'log' and adding two default tags
// 'dolog' and 'completed tasks'

var outputString: String = "dayone2 --journal log --tags dolog completed\\ tasks "

// MARK: - Process input

//-- Test if tags are present

// weHaveTags is true if there are tags present

let weHaveTags = argument.hasPrefix("-t")

//-- Process tags if present, otherwise just pass the input

if weHaveTags {
	
	// find the index of the tags separator
	
	if let endOfTags = argument.characters.index(of: "@") {

		// Map the tags into an array. The first tag (index 0) will be the tag option marker (-t) and will be
		// omitted
		
		let tags = String(argument.characters.prefix(upTo: endOfTags)).characters.split(separator: " ").map{ String($0) }
		
		// Now process the task part to remove the end of tags marker
		
		// get the task part of the inpu
		
		let taskSection = String(argument.characters.suffix(from: endOfTags))
		
		// find the index of the tags separator in this string (different than above)
		
		let endTagIndex = taskSection.characters.index(of: "@")!
		
		// The task proper starts after the tags separator
		
		let tagIndex = taskSection.characters.index(after: endTagIndex)

		// get the task
		
		task = String(taskSection.characters.suffix(from: tagIndex))
		
		// Add the tags to the output string separated by spaces
			
		for i in 1..<tags.count {
			
			// first we process underscores (_) in tags to replace them with escaped spaces so they're
			// treated as a single tag
			
			let tag = tags[i].replacingOccurrences(of: "_", with: "\\ ")
			
			// add this processed tag to the output string
			
			outputString += tag + " "
		}
	} else {

		// user forgot the '@' separator so just pass the input string (task) as received
	
		task = argument
		
	}
		
} else {
	
	// no tags, so just pass the input string (task) as received
	
	task = argument
}

// Add the task to the output string (enclosed in quotes to prevent the CLI to interpret special characters)

outputString += " -- new completed: \"" + task + "\""

// pass the result of the script, we suppress the newline character in the output

print(outputString, terminator:"")