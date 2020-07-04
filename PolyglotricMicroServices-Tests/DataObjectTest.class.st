"
A DataObjectTest is a test class for testing the behavior of DataObject
"
Class {
	#name : #DataObjectTest,
	#superclass : #TestCase,
	#category : #'PolyglotricMicroServices-Tests'
}

{ #category : #tests }
DataObjectTest >> testAccessing [

	| dummy  data |
	
	
	data := { #instVar1 -> 'hello' } asDictionary .
	dummy := Dummy newFromData: data.
	
	self assert: dummy instVar1 equals: 'hello'
]

{ #category : #tests }
DataObjectTest >> testAccessingToSecondLevel [

	| dummy  data |
	
	
	data := { #instVar1 -> 'hello'. #instVar2 -> {#instVar3 -> 'goodbye'  } asDictionary  } asDictionary .
	dummy := Dummy newFromData: data.
	
	self assert: dummy instVar1 equals: 'hello'.
	self assert: (dummy instVar2 isKindOf: Dummy2).
	self assert: dummy instVar2 instVar3 equals: 'goodbye'.
]

{ #category : #tests }
DataObjectTest >> testAccessingToThirdLevel [

	| dummy  data |
	
	
	data := { #instVar1 -> 'hello'. 
				 #instVar2 -> {#instVar3 -> 'goodbye'. 
									#instVar4 -> {#instVar5 -> 'goodnite'  } asDictionary   } asDictionary  } asDictionary .
	dummy := Dummy newFromData: data.
	
	self assert: dummy instVar1 equals: 'hello'.
	self assert: (dummy instVar2 isKindOf: Dummy2).
	self assert: dummy instVar2 instVar3 equals: 'goodbye'.
	self assert: (dummy instVar2 instVar4 isKindOf: Dummy3).
	self assert: dummy instVar2 instVar4 instVar5 equals: 'goodnite'.
	dummy inspect.
	
]
