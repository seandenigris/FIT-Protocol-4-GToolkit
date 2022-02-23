Class {
	#name : #FpFITDataResource,
	#superclass : #RlResource,
	#category : #'FIT Protocol'
}

{ #category : #accessing }
FpFITDataResource class >> allFromFiles [
	| fitFiles |
	fitFiles := (FileLocator dynabookData / 'FIT' / 'FIT Data Files') filesMatching: '*.fit'.
	^ fitFiles collect: [ :e | self on: e ]
]

{ #category : #'file types' }
FpFITDataResource class >> fileExtensions [
	^ #('fit')
]

{ #category : #accessing }
FpFITDataResource >> activity [
	^ FpFitActivity fromResource: self
]

{ #category : #accessing }
FpFITDataResource >> csv [
	| csvResource rawRecords records |
	self csvFileReference exists ifFalse: [ self exportAsCSV ].
	csvResource := RlCSV on: self csvFileReference.
	^ csvResource asArraysOfStrings
]

{ #category : #accessing }
FpFITDataResource >> csvFileReference [
	^ self file parent / 'CSV Cache' / self file base, 'csv'
]

{ #category : #accessing }
FpFITDataResource >> exportAsCSV [
	| finalReference |
	SuGenericUnixCommand new
		template: 'java -jar {csvToolJar} {fitFile}';
		argumentAt: #csvToolJar put: '/Users/sean/Documents/Reference/Smalltalk/User Data/FIT/FitSDKRelease_21.67.00/java/FitCSVTool.jar' asFileReference;
		argumentAt: #fitFile put: self file;
		run.
	
	self file withoutExtension, 'csv' moveTo: self csvFileReference.
	
	^ RlCSV on: self csvFileReference
]
