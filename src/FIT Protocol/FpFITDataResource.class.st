Class {
	#name : #FpFITDataResource,
	#superclass : #RlResource,
	#category : #'FIT Protocol'
}

{ #category : #'file types' }
FpFITDataResource class >> fileExtensions [
	^ #('fit')
]

{ #category : #accessing }
FpFITDataResource >> csv [
	| csvFile csvResource rawRecords records |
	csvFile := self file withoutExtension, 'csv'.
	csvFile exists ifFalse: [ self exportAsCSV ].
	csvResource := RlCSV on: csvFile.
	rawRecords := (csvResource asArraysOfStrings allButFirst: 10) allButLast: 2.
	records := rawRecords collect: [ :e | FpFitRecord on: e ].
	^ FpFitActivity new
		data: records;
		yourself
]

{ #category : #accessing }
FpFITDataResource >> exportAsCSV [
	SuGenericUnixCommand new
		template: 'java -jar {csvToolJar} {fitFile}';
		argumentAt: #csvToolJar put: '/Users/sean/Documents/Reference/Smalltalk/User Data/FIT/FitSDKRelease_21.67.00/java/FitCSVTool.jar' asFileReference;
		argumentAt: #fitFile put: self file;
		run.
		
	^ RlCSV on: self file withoutExtension, 'csv'
]
