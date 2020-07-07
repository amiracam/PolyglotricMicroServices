Class {
	#name : #PropertiesReader,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : #'PolyglotricMicroServices-utilities'
}

{ #category : #'instance creation' }
PropertiesReader class >> readFrom: path [
	
	^ self readFrom: path commentCharacter: '#'
	
]

{ #category : #'instance creation' }
PropertiesReader class >> readFrom: path commentCharacter: aChar [
	| string |
	
	string := path asFileReference contents.
	
	^self readFromString: string commentPrefix: aChar.
]

{ #category : #'instance creation' }
PropertiesReader class >> readFromString: aString commentPrefix: aChar [
	| dict prop rs |
	
	dict := Dictionary new.

	aString
		linesDo: [ :eaLn | 
			(eaLn beginsWith: aChar)
				ifFalse: [ | tokens |
					tokens := eaLn splitOn: $=.
					tokens size = 2
						ifTrue: [ dict at: tokens first trim asLowercase asSymbol put: tokens second trim ]
					]
			].

	prop := self new data: dict.
	rs := prop beReadOnlyObject .
	self assert: rs not description: 'Not able to make properties readOnly !'.
	
	^prop
		
]

{ #category : #accessing }
PropertiesReader >> data: anObject [
	data := anObject
]

{ #category : #'reflective operations' }
PropertiesReader >> doesNotUnderstand: aMessage [

	| selector |
	
	^ ((selector := aMessage selector) isUnary)
		ifTrue: [ data at: selector asLowercase ifAbsent:[] ]
		ifFalse:[self error: 'illegal selector: ' , selector]
]

{ #category : #initialization }
PropertiesReader >> initialize [ 

	data := Dictionary new.
]

{ #category : #testing }
PropertiesReader >> isLoaded [ 

	^ data keys size > 0
]
