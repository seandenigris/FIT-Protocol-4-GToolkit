Class {
	#name : #RlFITData,
	#superclass : #RlResource,
	#category : #'FIT Protocol'
}

{ #category : #'file types' }
RlFITData class >> fileExtensions [
	^ #('fit')
]

{ #category : #accessing }
RlFITData >> csv [
	| csvFile csvResource |
	csvFile := self file withoutExtension, 'csv'.
	csvFile exists ifFalse: [ self exportAsCSV ].
	csvResource := RlCSV on: csvFile.
	^ csvResource asArraysOfStrings allButFirst: 10
]

{ #category : #accessing }
RlFITData >> exportAsCSV [
	SuGenericUnixCommand new
		template: 'java -jar {csvToolJar} {fitFile}';
		argumentAt: #csvToolJar put: '/Users/sean/Documents/Reference/Smalltalk/User Data/FIT/FitSDKRelease_21.67.00/java/FitCSVTool.jar' asFileReference;
		argumentAt: #fitFile put: self file;
		run.
		
	^ RlCSV on: self file withoutExtension, 'csv'
]
