Extension { #name : #GtPlotterTimeEveryHour }

{ #category : #'*FIT Protocol' }
GtPlotterTimeEveryHour >> durationsFrom: aStartDuration to: anEndDuration do: aBlock [
	| aCounter aCeilStart aFloorEnd |

	aCounter := 0.
	aCeilStart := (aStartDuration / 1 hour) ceiling.
	aFloorEnd := (anEndDuration / 1 hour) floor.

	aCeilStart to: aFloorEnd do: [ :anAmountOfHourss |
			aCounter % step = 0
				ifTrue: [ aBlock value: (GtPlotterDuration hours: anAmountOfHourss) ].
			aCounter := aCounter + 1 ]
]
