Class {
	#name : #SystemLauncher,
	#superclass : #ExtendedService,
	#instVars : [
		'services',
		'isDevelopment'
	],
	#category : #PolyglotricMicroServices
}

{ #category : #private }
SystemLauncher >> compositeFutureFor: allFutures [
	^ self futureFactory all: allFutures.
]

{ #category : #private }
SystemLauncher >> futureFactory [
	^ TKTFuture.
]

{ #category : #initialization }
SystemLauncher >> initialize [
	ServiceRegistry new.
	super initialize.
	self launch.
]

{ #category : #'accessing-testing' }
SystemLauncher >> isDevelopment [
	^isDevelopment 
		ifNil: [ isDevelopment := (configuration at: 'isDevelopment') = 'true'. ]
	
]

{ #category : #private }
SystemLauncher >> launch [
	""
	| registeredServices |
	
	self logInfo: 'Launching registered services: ', services asString.
	
	(self compositeFutureFor: self registeredServiceFutures)
		onSuccessDo: [ :ignored | self logInfo: 'Successful deployment of all services !' ];
		onFailureDo: [ :failure | 
			self logInfo: failure description.
			self logInfo: 'Failed to deploy , shutting down.'.
			self undeploy
			].
]

{ #category : #initialization }
SystemLauncher >> postLoadConfiguration [

	services := 
		(configuration at: 'services')
			collect: [ :ea | Smalltalk at: ea asSymbol ].
]

{ #category : #private }
SystemLauncher >> registeredServiceFutures [
	^ services collect: [ :ea | [ ea deploy ] future ]
]

{ #category : #running }
SystemLauncher >> stop [
	"no op"
	
]

{ #category : #'as yet unclassified' }
SystemLauncher >> undeploy [
	self logInfo: 'Undeploying services: ' , services asString.
	registry ifNotNil: [ registry stop ].
	logger := nil.
	registry := nil.
	services
		do:
			[ :ea | (ea perform: #allInstances) do: [ :inst | inst becomeForward: nil ] ].
	services := nil.
	self becomeForward: nil.
]
