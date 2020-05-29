Class {
	#name : #MongoService,
	#superclass : #ExtendedService,
	#instVars : [
		'client',
		'logs'
	],
	#category : #PolyglotricMicroServices
}

{ #category : #initialization }
MongoService >> initLogDatabase [
	
	logs := ((client databaseNamed:'service') getCollection: 'logs').
		
]

{ #category : #initialization }
MongoService >> initialize [
	"setup http server and routes"

	super initialize.
	self startClient.
	self initLogDatabase.
	self log: 'Mongo Service started successfully'
]

{ #category : #'start-stop' }
MongoService >> log: aMessage [

	self logInfo: 'Mongo Service started successfully'.
	logs add: { #msg -> aMessage  } asDictionary 
]

{ #category : #'start-stop' }
MongoService >> startClient [

	client := Mongo host: (configuration at: 'host') port: (configuration at: 'port') asInteger.
	client open.
	
]

{ #category : #'start-stop' }
MongoService >> stop [ 

	client closeIfOpen.
	self logInfo: 'Mongo Service stopped'
]
