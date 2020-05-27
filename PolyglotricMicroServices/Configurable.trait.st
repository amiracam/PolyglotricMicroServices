Trait {
	#name : #Configurable,
	#instVars : [
		'configuration'
	],
	#category : #PolyglotricMicroServices
}

{ #category : #accessing }
Configurable >> configuration [
	^ configuration
]

{ #category : #running }
Configurable >> enforceUnixPath: aPathString [

	^ aPathString copyWithRegex: '\\' matchesReplacedWith: '/'
]

{ #category : #running }
Configurable >> loadConfiguration [
	""

	| fn |
	fn := self defaultConfigurationPath asFileReference.

	configuration := fn exists 
		ifTrue: [ fn readStream upToEnd asJson ]
		ifFalse: [ Dictionary new ].
	self postLoadConfiguration.
]

{ #category : #running }
Configurable >> postLoadConfiguration [
	"do nothing by default"

	
]
