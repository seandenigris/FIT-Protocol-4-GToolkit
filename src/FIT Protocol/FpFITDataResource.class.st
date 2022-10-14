Class {
	#name : #FpFITDataResource,
	#superclass : #RlResource,
	#category : #'FIT Protocol'
}

{ #category : #accessing }
FpFITDataResource class >> allFromFiles [
	| fitFiles |
	fitFiles := (self rootFolder / 'FIT Data Files') filesMatching: '*.fit'.
	^ fitFiles collect: [ :e | self on: e ]
]

{ #category : #utilites }
FpFITDataResource class >> decodeDate: aString [
	^ '12/31/1989' asDate asDateAndTime translateToUTC + aString asNumber seconds offset: LocalTimeZone new offset
]

{ #category : #'file types' }
FpFITDataResource class >> fileExtensions [
	^ #('fit')
]

{ #category : #accessing }
FpFITDataResource class >> rootFolder [
	^ FileLocator dynabookData / 'FIT'
]

{ #category : #accessing }
FpFITDataResource >> activity [
	^ FpFitActivity fromResource: self
]

{ #category : #accessing }
FpFITDataResource >> csv [
	| csvResource |
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
	SuGenericUnixCommand new
		template: 'java -jar {csvToolJar} {fitFile}';
		argumentAt: #csvToolJar put: self rootFolder / 'Fit SDK' / 'java' / 'FitCSVTool.jar';
		argumentAt: #fitFile put: self file;
		run.

	self file withoutExtension , 'csv' moveTo: self csvFileReference.

	^ RlCSV on: self csvFileReference
]

{ #category : #accessing }
FpFITDataResource >> rootFolder [

	^ self class rootFolder
]
