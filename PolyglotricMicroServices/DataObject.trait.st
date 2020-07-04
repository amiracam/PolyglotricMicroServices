Trait {
	#name : #DataObject,
	#instVars : [
		'data'
	],
	#category : #PolyglotricMicroServices
}

{ #category : #'instance creation' }
DataObject classSide >> newFromData: aDictionary [

	| inst |
	inst := self new.
	inst instVarAt: (self instVarNames indexOf: #data) put: aDictionary.
	^inst 
]

{ #category : #'reflective operations' }
DataObject >> doesNotUnderstand: aMessage [

	| specs selector |
	
	^((selector := aMessage selector) isUnary and: [ self class instVarNames includes: selector ])
		ifTrue: [ specs := self replicationSpec asDictionary.
					(specs at: selector ifAbsent: [[:v | v] ]) value: (data at: selector)	
				 ]
		ifFalse: [super doesNotUnderstand: aMessage]
]

{ #category : #'as yet unclassified' }
DataObject >> replicationSpec [

	^{} 
]
