Class {
	#name : #BaselineOfFITProtocol,
	#superclass : #BaselineOf,
	#category : #BaselineOfFITProtocol
}

{ #category : #testing }
BaselineOfFITProtocol class >> isDynabook [
	^ true
]

{ #category : #baselines }
BaselineOfFITProtocol >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec 
			baseline: 'DataFrame' with: [
				spec repository: 'github://polymathorg/DataFrame' ];
			baseline: 'ResourcesLive' with: [
				spec repository: 'github://seandenigris/Resources-Live' ];
			baseline: 'SimplePersistence' with: [
				spec repository: 'github://seandenigris/Simple-Persistence' ];
			package: #'Fit Protocol'  with: [
				spec requires: #(#'DataFrame' #'ResourcesLive' ) ] ]
]
