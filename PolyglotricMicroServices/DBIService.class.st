Class {
	#name : #DBIService,
	#superclass : #HttpService,
	#traits : 'TBConfigurable',
	#classTraits : 'TBConfigurable classTrait',
	#category : #PolyglotricMicroServices
}

{ #category : #'initailize-release' }
DBIService >> initializeRoutes [
	super initializeRoutes.

	server 
		POST: '/runProc' -> [ :request | self runProcedure: request ].
]

{ #category : #routes }
DBIService >> runProcedure: request [

	|  msgPackage dict eventList |
	self logInfo: 'I HttpService received connect request'.
	msgPackage := request contents asJson.
	msgPackage at: #selector put: #runProcedure:.
	
	"Assumes async fire/forget but some functions have a an expected return value / msg"
	"Validate event list"
	
	eventList := (msgPackage at: #eventList) splitOn: Character cr.
	eventList size = (msgPackage at: 'arraySize')
		ifFalse: [^ ZnResponse new
		statusLine: ZnStatusLine badRequest ;
		entity: (ZnEntity json: (NeoJSONWriter toString: (Dictionary new at: #response put: 'Array size doesnt match event size.';yourself) ));
		yourself. ] 
	ifTrue:[msgPackage at: #eventList put: eventList].
	 
	
	 self
		send: msgPackage
		to: #TBFunctionDispatcher
		from: self.

	^ ZnResponse new
		statusLine: ZnStatusLine ok;
		entity: (ZnEntity json: (NeoJSONWriter toString: dict));
		yourself.
]
