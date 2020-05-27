Class {
	#name : #BaselineOfPolyglotricMicroServices,
	#superclass : #BaselineOf,
	#category : #BaselineOfPolyglotricMicroServices
}

{ #category : #baselines }
BaselineOfPolyglotricMicroServices >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ self setupDependencies: spec.
			spec
				package: 'PolyglotricMicroServices'
				with: [ spec requires: #('Teapot' 'MongoTalk' 'SimpleRedisClient') ] ]
]

{ #category : #accessing }
BaselineOfPolyglotricMicroServices >> projectClass [
	^ MetacelloCypressBaselineProject
]

{ #category : #baselines }
BaselineOfPolyglotricMicroServices >> setupDependencies: spec [

	spec baseline: 'Teapot' 					with: [ spec repository: 'github://zeroflag/Teapot:master/source';	loads: #('Deployment') ];import: 'Teapot'.
	spec baseline: 'MongoTalk'				with: [ spec repository: 'github://pharo-nosql/mongotalk/mc'; 		loads: #('Client') ]; import: 'MongoTalk.'.
	spec baseline: 'SimpleRedisClient' 	with: [ spec repository: 'github://svenvc/SimpleRedisClient' ]; 		import: 'SimpleRedisClient.'.
	spec baseline: 'P3' 						with: [ spec repository: 'github://svenvc/P3' ]; 							import: 'P3'
]
