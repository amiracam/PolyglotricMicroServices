Class {
	#name : #Dummy2,
	#superclass : #Object,
	#traits : 'DataObject',
	#classTraits : 'DataObject classTrait',
	#category : #'PolyglotricMicroServices-Tests'
}

{ #category : #'as yet unclassified' }
Dummy2 >> attributes [ 
	^#(instVar3 instVar4)
]

{ #category : #'as yet unclassified' }
Dummy2 >> replicationSpec [

	^{#instVar4 -> [:v | Dummy3 newFromData: v]} 
]
