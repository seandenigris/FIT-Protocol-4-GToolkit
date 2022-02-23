Class {
	#name : #FpFitRecord,
	#superclass : #Object,
	#instVars : [
		'rawData'
	],
	#category : #'FIT Protocol'
}

{ #category : #accessing }
FpFitRecord class >> on: anArray [

	^ self new
		rawData: anArray;
		yourself
]

{ #category : #accessing }
FpFitRecord >> cadence [
	^ (self rawData at: 8) asNumber
]

{ #category : #accessing }
FpFitRecord >> pelotonResistance [
	"This is a rough generalization for Echelon -> Peloton conversion. We could make this user configurable if the need arises. See comment at end for more info"
	| pelotonRange echelonRange echelonResistance |
	pelotonRange := 20 to: 100.
	echelonRange := 9 to: 32.
	
	echelonResistance := (self rawData at: 20) asNumber.
	^ ((echelonResistance - echelonRange min) * pelotonRange range / echelonRange range) + pelotonRange min.
	
	"Echelon to Peloton resistance conversion: Apparently, if you want to be really accurant, you can figure this out for yourself based on your actual bike (each bike's calibration varies). There is a guide on how to do this at https://www.reddit.com/r/pelotoncycle/wiki/index/resistancechart"
]

{ #category : #accessing }
FpFitRecord >> power [
	^ (self rawData at: 17) asNumber
]

{ #category : #accessing }
FpFitRecord >> rawData [
	^ rawData
]

{ #category : #'as yet unclassified' }
FpFitRecord >> rawData: anArray [
	rawData := anArray
]

{ #category : #accessing }
FpFitRecord >> time [
	^ self timestamp asTime
]

{ #category : #accessing }
FpFitRecord >> timestamp [
	^ FpFITDataResource decodeDate: (self rawData at: 29)
]
