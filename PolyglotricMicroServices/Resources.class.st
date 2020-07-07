Class {
	#name : #Resources,
	#superclass : #Object,
	#traits : 'Loggable',
	#classTraits : 'Loggable classTrait',
	#instVars : [
		'bootTime'
	],
	#classVars : [
		'DbTypes'
	],
	#category : #'PolyglotricMicroServices-service'
}

{ #category : #initialization }
Resources class >> dbTypes [
	^DbTypes
		ifNil: [ 
			self initializeDbTypes.
			DbTypes
			].
]

{ #category : #initialization }
Resources class >> initializeDbTypes [
	"self initializeDbTypes"

	DbTypes := Dictionary new.
	
	^ DbTypes
		at: #oracle put: 'oracle';
		at: #ora put: 'oracle';
		at: #orat put: 'oracle';
		at: #postgresql put: 'postgresql';
		at: #pg put: 'postgresql';
		at: #pgc put: 'postgresql';
		yourself
]

{ #category : #initialization }
Resources class >> inititalize [
	self initializeDbTypes.
]

{ #category : #'instance creation' }
Resources class >> inst: clientMoniker home: homePath [ 

	^ (self basicNew)
		clientInst: clientMoniker ;
		home: homePath;
		initialize;
		beReadOnlyObject;
		yourself 
]

{ #category : #'instance creation' }
Resources class >> new [ 
	self shouldNotImplement 
]

{ #category : #accessing }
Resources >> bootTime [
	^ bootTime
]

{ #category : #accessing }
Resources >> bootTime: anObject [
	bootTime := anObject
]

{ #category : #initialization }
Resources >> initialize [

	bootTime := Time now.	
	self initializeLogger.
]

{ #category : #accessing }
Resources >> logger [
	^ logger
]

{ #category : #accessing }
Resources >> logger: anObject [
	logger := anObject
]
