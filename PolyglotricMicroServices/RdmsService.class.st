Class {
	#name : #RdmsService,
	#superclass : #ExtendedService,
	#instVars : [
		'client',
		'rdmsConnectionPool',
		'queryRegistry'
	],
	#classVars : [
		'ExceptionAnnouncer'
	],
	#category : #'PolyglotricMicroServices-service'
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
			self halt. 
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

{ #category : #'as yet unclassified' }
RdmsService >> executeNamedQuery: queryName withArguments: queryArgs [

	| sql |
	
	sql := (configuration at: 'queryRegistry') at: queryName .
	

	
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
RdmsService >> loadDatabaseConnectionPoolFactory [
	
	| poolID |
	^(poolID := configuration at: #rdmsConnectionPool ifAbsent: [self error: 'Database broker not specified !'  ])
		ifNotNil: [Smalltalk at: poolID asSymbol ].
]

{ #category : #acccessing }
RdmsService >> serverUrl [
	^(configuration at: 'url') trim.
]

{ #category : #running }
RdmsService >> stop [
	
	self logInfo: 'Shutting down rdms client'.
	
	client ifNotNil: [ :c | c close ].
	client := nil.
	logger := nil.
	
]
