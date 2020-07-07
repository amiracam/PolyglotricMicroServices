Class {
	#name : #ServiceRegistry,
	#superclass : #Object,
	#instVars : [
		'registry',
		'configuration'
	],
	#classVars : [
		'singleton'
	],
	#category : #'PolyglotricMicroServices-service'
}

{ #category : #'instance creation' }
ServiceRegistry class >> clearSingleton [
	singleton := nil.
]

{ #category : #'instance creation' }
ServiceRegistry class >> new [ 
	^ singleton ifNil: [ singleton := self basicNew initialize ]
]

{ #category : #'instance creation' }
ServiceRegistry class >> stop [
	singleton ifNotNil: [ :s | s stopInstance ].
	self clearSingleton.
]

{ #category : #initialization }
ServiceRegistry >> initialize [ 

	registry  := IdentityDictionary new.
]

{ #category : #initialization }
ServiceRegistry >> register: actor by: id [
""
	registry at: id put: actor.
]

{ #category : #initialization }
ServiceRegistry >> send: aMessage to: actor from: sender [
	"handle async , use send response to sender ? use TKActors ?"

	^ (registry at: actor) receiveMessage: aMessage.
]

{ #category : #release }
ServiceRegistry >> stop [

	self class stop
]

{ #category : #release }
ServiceRegistry >> stopInstance [ 

	registry do: [ :ea | ea ifNotNil: [:v | v stop ]].
	registry := nil.
]
