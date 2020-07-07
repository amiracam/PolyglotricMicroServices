Class {
	#name : #Dummy,
	#superclass : #Object,
	#traits : 'DataObject',
	#classTraits : 'DataObject classTrait',
	#category : #'PolyglotricMicroServices-Tests'
}

{ #category : #'as yet unclassified' }
Dummy >> attributes [ 
	^#(instVar1 instVar2 instVar3)
]

{ #category : #'as yet unclassified' }
Dummy >> replicationSpec [

	^{#instVar2 -> [:v | Dummy2 newFromData: v]} 
]
