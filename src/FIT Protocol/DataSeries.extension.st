Extension { #name : #DataSeries }

{ #category : #'*FIT Protocol' }
DataSeries >> gtStatsViewFor: aView [
	<gtView>

	| valuator |
	valuator := [ :sel | 
		| val |
		val := self perform: sel.
		(val isKindOf: Fraction)
			ifTrue: [ val asFloat ]
			ifFalse: [ val ] ].
				
	^ aView columnedList
		title: 'Stats';
		priority: 500;
		items: [ #( average median max min mode range zerothQuartile
			firstQuartile secondQuartile thirdQuartile fourthQuartile
			interquartileRange stdev variance ) ];
		column: 'Metric' translated text: [ :each | each ];
		column: 'Value' translated text: valuator;
		send: valuator
]
