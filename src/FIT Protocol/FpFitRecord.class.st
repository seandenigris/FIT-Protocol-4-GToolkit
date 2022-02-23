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
	| pelotonRange echelonRange echelonResistance |
	pelotonRange := 20 to: 100.
	echelonRange := 9 to: 32.
	
	echelonResistance := (self rawData at: 20) asNumber.
	^ ((echelonResistance - echelonRange min) * pelotonRange range / echelonRange range) + pelotonRange min.
	
	"Echelon to Peloton resistance conversion: Apparently, you can figure this out for yourself based on your actual bike (their calibration varies)

https://imgur.com/gallery/9ZqPA1w is apparently from a power meter"
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
	^ '12/31/1989' asDate asDateAndTime translateToUTC + (self rawData at: 29) asNumber seconds offset: LocalTimeZone new offset
]
