Class {
	#name : #TBFunctionDispatcher,
	#superclass : #RdmsFunctionDispatcher,
	#traits : 'TBConfigurable',
	#classTraits : 'TBConfigurable classTrait',
	#category : #PolyglotricMicroServices
}

{ #category : #messages }
TBFunctionDispatcher >> announceException: ex [
	RdmsService exceptionAnnouncer
		announce: (RdmsAnnouncement new message: ex description).
]

{ #category : #messages }
TBFunctionDispatcher >> announceProcessedEvent: anEvent [
	^ RdmsService exceptionAnnouncer
		announce:
			(RdmsAnnouncement new
				message: ('Processed event: {1}' format: {anEvent.})).
]

{ #category : #'name resolutions' }
TBFunctionDispatcher >> connectionMapFor: user and: password [

	^ {
	(#user -> user).
	(#pass -> password).
	(#dbHost -> appConfiguration db_host).
	(#dbSvcn -> appConfiguration db_svcn).
	(#tb_envt -> appConfiguration tb_envt).
	} asDictionary.
]

{ #category : #'name resolutions' }
TBFunctionDispatcher >> currentDatabaseType [
	^ appConfiguration db_type.
]

{ #category : #'instance creation' }
TBFunctionDispatcher >> newEventFrom: evData [
	^ self rdmsEventFactory newFrom: evData.
]

{ #category : #'name resolutions' }
TBFunctionDispatcher >> oracleConnectionStringFor: user and: password [

	^ 'jdbc:oracle:thin{user}/{pass}/{dbHost}.{dbSvcn}' format: (self connectionMapFor: user and: password )
]

{ #category : #'name resolutions' }
TBFunctionDispatcher >> postgresqlConnectionStringFor: user and: password [
	"psql://TEST_TBOSSS_ADMIN1:ADMIN1@192.168.40.107:5432/TEST_TBOSSS"

	^ 'psql://{user}:{pass}@{dbHost}/{tb_envt}_{dbSvcn}'
			format: (self connectionMapFor: user and: password).
]

{ #category : #'as yet unclassified' }
TBFunctionDispatcher >> rdmsEventFactory [
	^ TBClientEvent 
]

{ #category : #services }
TBFunctionDispatcher >> rdmsFunctionFactory [
	^ TBStoredProcedure.
]

{ #category : #messages }
TBFunctionDispatcher >> runProcedure: anEvent [
| events |
self halt. 
	events := (anEvent at: 'eventList') collect: [ :ea | self newEventFrom: ea ].
	anEvent at: 'eventList' put: events.
	client
		withConnection: [ :conn | 
			[ self serverTransactionFactory forEvent: anEvent on: conn.
			  self announceProcessedEvent: anEvent
			]
				on: TransactionAborted
				do: [ :ex | 
					self announceException: ex.
					^ ex return
					]
			].
]

{ #category : #services }
TBFunctionDispatcher >> serverTransactionFactory [
	^ TBServerTransaction 
]
