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
	| dummy data |
	data := { 
		        (#instVar1 -> 'hello').
		        (#instVar3 -> { 
			         (#key1 -> 1).
			         (#key2 -> 2) } asDictionary) } asDictionary.
	dummy := Dummy newFromData: data.
	self assert: (dummy instVar3 at: #key1) equals: 1.
	self assert: dummy instVar1 equals: 'hello'
]

{ #category : #tests }
DataObjectTest >> testAccessingToSecondLevel [
	| dummy data |
	
	data := { 
		        (#instVar1 -> 'hello').
		        (#instVar2 -> { (#instVar3 -> 'goodbye') } asDictionary) }
		        asDictionary.
		
	dummy := Dummy newFromData: data.
	self assert: (dummy instVar2 isKindOf: Dummy2).
	self assert: dummy instVar2 instVar3 equals: 'goodbye'
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

	
]

{ #category : #tests }
DataObjectTest >> testAsDictionaryFlat [
	| dummy |
	
	
	
	dummy := Dummy new.
	dummy instVar1: 'hello'.
	self assert: 'hello' equals: dummy instVar1 
]

{ #category : #tests }
DataObjectTest >> testAsDictionaryToSecondLevel [
	| dummy dummy2 |
	
	
	
	dummy := Dummy new.
	dummy instVar1: 'hello'.
	dummy2 := Dummy2 new instVar3: 'there'; yourself.
	dummy instVar2: dummy2.
	self assert: 'there' equals: dummy instVar2 instVar3 
]

{ #category : #tests }
DataObjectTest >> testDictionaryRepresentation [
	| dummy dict |
	
	
	
	dummy := Dummy new.
	dummy instVar1: 'hello'.
	dict := dummy asDictionary.
	self assert: (dict at: #instVar1) equals: 'hello'.
	self assert: 'hello' equals: dummy instVar1 
]
