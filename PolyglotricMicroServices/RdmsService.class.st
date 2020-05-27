Class {
	#name : #RdmsService,
	#superclass : #ExtendedService,
	#instVars : [
		'client',
		'rdmsConnectionPool'
	],
	#classVars : [
		'ExceptionAnnouncer'
	],
	#category : #PolyglotricMicroServices
}

{ #category : #announcements }
RdmsService class >> exceptionAnnouncer [
	"comment stating purpose of class-side message"

	ExceptionAnnouncer ifNil: [ ExceptionAnnouncer := Announcer new ].
	^ExceptionAnnouncer 
]

{ #category : #initialization }
RdmsService >> checkConnectionStatus [
	| result |
	result := [ rdmsConnectionPool
		withConnection: [ :conn | conn isWorking ] ]
		on: Exception
		do: [ :ex | 
			self logInfo: ex messageText.
			ex return: false
			].
	result
		ifTrue:
			[ self logInfo: 'Succesfully connected to database @' , self serverUrl ]
		ifFalse: [ self logInfo: 'Not able to connect to database @' , self serverUrl.
			self error: 'Not able to connect to database'
			]
	
]

{ #category : #services }
RdmsService >> connect: aMessage [
	self subclassResponsibility 
]

{ #category : #acccessing }
RdmsService >> connectionPoolFactory [
	^ self loadDatabaseConnectionPoolFactory 
]

{ #category : #initialization }
RdmsService >> connectionPoolSize [
	^ (configuration at: 'connectionPoolSize')
]

{ #category : #'name resolutions' }
RdmsService >> connectionUrlFor: user and: password [
	"Return String"

	| dbType |
	
	dbType := self resolveDbTypeFor: self currentDatabaseType.

	^ self
		perform: (dbType, 'ConnectionStringFor:and:') asSymbol
		withArguments: {user. password }.
]

{ #category : #'name resolutions' }
RdmsService >> dbTypes [
	^ DbTypes.
]

{ #category : #testing }
RdmsService >> generateBootstrapDBURL [

	| bootstrapUser bootstrapPass  |
	bootstrapUser := configuration at: #bootstrap_user.
	bootstrapPass := configuration at: #bootstrap_pass.
	
	^self connectionUrlFor: bootstrapUser and: bootstrapPass.
	
	
]

{ #category : #initialization }
RdmsService >> initialize [
	"grab url from config file later"
	super initialize.
	self initializeDatabaseConnection.
]

{ #category : #initialization }
RdmsService >> initializeDatabaseConnection [

	rdmsConnectionPool  :=
	 self connectionPoolFactory new
		url: self serverUrl;
		size: self connectionPoolSize.

	self checkConnectionStatus.
]

{ #category : #initialization }
RdmsService >> initializeLogger [
	"grab url from config file later"
	
	super initializeLogger.
	self class exceptionAnnouncer
		when: RdmsAnnouncement
		do: [ :event | 
			self logInfo: event message 
			].
]

{ #category : #initialization }
RdmsService >> loadDatabaseConnectionPoolFactory [
	
	| poolID |
	^(poolID := configuration at: #rdmsConnectionPool ifAbsent: [self error: 'Database broker not specified !'  ])
		ifNotNil: [Smalltalk at: poolID asSymbol ].
]

{ #category : #'name resolutions' }
RdmsService >> resolveDbTypeFor: dbMoniker [

	^ self dbTypes at: dbMoniker asLowercase asSymbol ifAbsent: [  ].
]

{ #category : #acccessing }
RdmsService >> serverUrl [
	^self generateBootstrapDBURL ifNil:[(configuration at: 'url') trim.]
	
]

{ #category : #running }
RdmsService >> stop [
	
	self logInfo: 'Shutting down rdms client'.
	
	client ifNotNil: [ :c | c close ].
	client := nil.
	logger := nil.
	
]

{ #category : #testing }
RdmsService >> testDatabaseAvailability [

	| bootstrapUser bootstrapPass url |
	bootstrapUser := configuration at: #bootstrap_user.
	bootstrapPass := configuration at: #bootstrap_pass.
	
	url := self connectionUrlFor: bootstrapUser and: bootstrapPass.
	
	^ self testConnection: url.  
]
