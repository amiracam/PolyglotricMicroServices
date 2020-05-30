Trait {
	#name : #Loggable,
	#instVars : [
		'logger'
	],
	#category : #PolyglotricMicroServices
}

{ #category : #initialization }
Loggable >> defaultLogFileName [
	^self class name
]

{ #category : #initialization }
Loggable >> initializeLogger [
	logger := Logger new.
 
	logger
		homeDir: self logFolder;
		filename: self defaultLogFileName .
]

{ #category : #initialization }
Loggable >> logFolder [
	
	^ './logs/'
]

{ #category : #logging }
Loggable >> logInfo: anObject [
	^ logger ifNotNil: [ :l | l info: anObject  ].
]
