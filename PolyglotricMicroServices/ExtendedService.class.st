"
Pull out configuration and logger into a Trait
"
Class {
	#name : #ExtendedService,
	#superclass : #Object,
	#traits : 'Configurable + Loggable',
	#classTraits : 'Configurable classTrait + Loggable classTrait',
	#instVars : [
		'registry',
		'id',
		'logger'
	],
	#category : #PolyglotricMicroServices
}

{ #category : #initialization }
ExtendedService class >> deploy [ 
	"For now just initialize"
	^ self new
]

{ #category : #acccessing }
ExtendedService >> clearLogger [
	logger := nil
]

{ #category : #acccessing }
ExtendedService >> id [
	^ id ifNil: [ id := self class name ].
]

{ #category : #initialization }
ExtendedService >> initialize [
	self loadConfiguration .
	self initializeLogger.
	registry := ServiceRegistry new.
	self register.
	
	
]

{ #category : #'message interception' }
ExtendedService >> receiveMessage: aMessageStructure [
	"aMessage for now a Dictionary"

	| selector aMessage |
	
	selector := aMessageStructure  at: #selector.
	^ self perform: selector with: aMessageStructure .
]

{ #category : #initialization }
ExtendedService >> register [
	self logInfo: 'Registering service: ' , self asString.
	registry register: self by: self id.
]

{ #category : #'message interception' }
ExtendedService >> send: aMessage to: actor from: sender [
	""

	^ registry send: aMessage to: actor from: sender.
]

{ #category : #initialization }
ExtendedService >> serviceRegistration [
	^ self 
]

{ #category : #running }
ExtendedService >> stop [ 
	"clean up and unschedule if appropriate"
	self subclassResponsibility 
]

{ #category : #running }
ExtendedService >> undeploy [

	self subclassResponsibility 
]
