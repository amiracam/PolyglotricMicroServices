Class {
	#name : #MongoService,
	#superclass : #ExtendedService,
	#category : #PolyglotricMicroServices
}

{ #category : #initialization }
MongoService >> initialize [
	"setup http server and routes"

	super initialize.
	self startClient.
]
