Class {
	#name : #FpFitActivity,
	#superclass : #Object,
	#instVars : [
		'data',
		'summary'
	],
	#category : #'FIT Protocol-FIT Protocol'
}

{ #category : #accessing }
FpFitActivity class >> allFromFiles [
	^ FpFITDataResource allFromFiles collect: [ :e | self fromResource: e ]
]

{ #category : #accessing }
FpFitActivity class >> decodeDate: aString [
	^ FpFITDataResource decodeDate: aString
]

{ #category : #'instance creation' }
FpFitActivity class >> fromResource: convertibleToResource [
	| rawData recordRows records |
	rawData := convertibleToResource asRlResource csv.
	recordRows := (rawData allButFirst: 10) allButLast: 2.
	records:= recordRows collect: [ :e | FpFitRecord on: e ].
	^ self new
		summary: (rawData at: 7);
		data: records;
		yourself
]

{ #category : #accessing }
FpFitActivity >> cadenceChart [
	^ self chart: #cadence
]

{ #category : #accessing }
FpFitActivity >> cadenceDataSeries [
	^ self dataSeries: #cadence.
]

{ #category : #accessing }
FpFitActivity >> chart: aSelector [

	| aData |
	aData := GtPlotterDataGroup new values: self data.
	aData := aData colored: Color blue.
	
	^ GtPlotterLineChart new
		with: aData;
		valueX: [ :e | e time asDuration - self data first time asDuration ];
		scaleX: GtPlotterDurationScale new;
		labelFormatX: #amount;
		titleX: 'Time (minutes)';
		ticksX: 10;
		valueY: aSelector;
		scaleY: GtPlotterLinearScale new;
		titleY: aSelector normalizeCamelCase capitalized;
		ticksY: 10.
]

{ #category : #accessing }
FpFitActivity >> data [
	^ data
]

{ #category : #'as yet unclassified' }
FpFitActivity >> data: aCollection [ 
	data := aCollection
]

{ #category : #accessing }
FpFitActivity >> dataFrame [
	| result |
	result := DataFrame withColumns: {
		self data collect: #cadence.
		self data collect: #pelotonResistance.
		self data collect: #power }.
	result 
		columnNames: #(cadence pelotonResistance power);
		rowNames: (self data collect: #time).
	^ result
]

{ #category : #accessing }
FpFitActivity >> dataSeries [
	^ DataSeries
        withKeys: (self data collect: [ :e | e timestamp asTime])
        values: (self data collect: [ :e | e cadence])
        name: #cadence.
]

{ #category : #accessing }
FpFitActivity >> dataSeries: aSelector [
	^ DataSeries
        withKeys: (self data collect: [ :e | e timestamp asTime ])
        values: (self data collect: [ :e | e perform: aSelector ])
        name: aSelector.
]

{ #category : #accessing }
FpFitActivity >> gtViewRecordsOn: aView [
	<gtView>
	^ aView list
		title: 'Records' translated;
		priority: 25;
		items: [ self data ]
]

{ #category : #accessing }
FpFitActivity >> pelotonResistanceChart [

	^ self chart: #pelotonResistance
]

{ #category : #accessing }
FpFitActivity >> pelotonResistanceDataSeries [

	^ self dataSeries: #pelotonResistance
]

{ #category : #accessing }
FpFitActivity >> powerChart [

	^ self chart: #power
]

{ #category : #accessing }
FpFitActivity >> powerDataSeries [
	^ self dataSeries: #power.
]

{ #category : #accessing }
FpFitActivity >> printOn: aStream [
	aStream
		nextPutAll: self startTime asDate mmddyyyy;
		nextPutAll: ' - cycling for ';
		print: self totalTime asMinutes rounded;
		nextPutAll: ' minutes (';
		print: (self totalDistance roundTo: 0.1);
		nextPutAll: ' miles, ';
		print: self totalCalories rounded;
		nextPutAll: ' calories';
		nextPutAll: ')'
]

{ #category : #accessing }
FpFitActivity >> startTime [
	^ self class decodeDate: self summary eighth
]

{ #category : #accessing }
FpFitActivity >> summary [

	^ summary
]

{ #category : #accessing }
FpFitActivity >> summary: anObject [

	summary := anObject
]

{ #category : #accessing }
FpFitActivity >> totalCalories [
	^ (self summary at: 20) asNumber
]

{ #category : #accessing }
FpFitActivity >> totalDistance [
	^ (self summary at: 17) asNumber "meters" * 0.00062 "to miles"
]

{ #category : #accessing }
FpFitActivity >> totalTime [
	^ (self summary at: 11) asNumber seconds
]
