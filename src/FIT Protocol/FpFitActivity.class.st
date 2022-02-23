Class {
	#name : #FpFitActivity,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : #'FIT Protocol-FIT Protocol'
}

{ #category : #'instance creation' }
FpFitActivity class >> fromResource: convertibleToResource [
	| rawData recordRows records |
	rawData := convertibleToResource asRlResource csv.
	recordRows := (rawData allButFirst: 10) allButLast: 2.
	records:= recordRows collect: [ :e | FpFitRecord on: e ].
	^ self new
		data: records;
		yourself
]

{ #category : #accessing }
FpFitActivity >> cadenceChart [
	^ self chart: #cadence
]

{ #category : #accessing }
FpFitActivity >> cadenceDataSeries [
	^ self dataSeries:  #cadence.
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
