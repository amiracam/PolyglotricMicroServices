Class {
	#name : #Dummy,
	#superclass : #Object,
	#traits : 'DataObject',
	#classTraits : 'DataObject classTrait',
	#instVars : [
		'instVar1',
		'instVar2'
	],
	#category : #'PolyglotricMicroServices-Tests'
}

{ #category : #'as yet unclassified' }
Dummy >> replicationSpec [

	^{#instVar2 -> [:v | Dummy2 newFromData: v]} 
]
