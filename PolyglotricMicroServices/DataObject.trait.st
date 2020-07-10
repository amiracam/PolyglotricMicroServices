Trait {
	#name : #DataObject,
	#instVars : [
		'_data'
	],
	#category : #'PolyglotricMicroServices-traits'
}

{ #category : #'instance creation' }
DataObject classSide >> newFromData: aDictionary [
	"set data dictionary on new instance , attribute access relies on said dictionary"
	| inst |
	inst := self new.
	inst instVarAt: (self allInstVarNames indexOf: #_data) put: aDictionary.
	^inst 
]

{ #category : #'as yet unclassified' }
DataObject >> asDictionary [
	^ _data ifNil: [ _data := Dictionary new ]
]

{ #category : #'as yet unclassified' }
DataObject >> attributes [ 
	^#()
]

{ #category : #'reflective operations' }
DataObject >> doesNotUnderstand: aMessage [
	| selector |
	^ (self attributes includes:
		   ((selector := aMessage selector) copyWithout: $:))
		  ifTrue: [ 
			  selector isUnary
				  ifTrue: [ 
					  | specs data |
					  specs := self replicationSpec asDictionary.
					  data := _data at: selector.
					  (data isKindOf: Dictionary)
						  ifTrue: [ "reify via spec translation block"
							  _data
								  at: selector
								  put: ((specs at: selector ifAbsent: [ [:v | v ] ]) value: data).
							  _data at: selector ]
						  ifFalse: [ data ] ]
				  ifFalse: [ 
					  _data ifNil: [ _data := Dictionary new ].
					  _data
						  at: (selector copyWithout: $:)
						  put: aMessage arguments first ] ]
		  ifFalse: [ super doesNotUnderstand: aMessage ]
]

{ #category : #'as yet unclassified' }
DataObject >> persistOn: dict useName: instVarName [ 
	
	dict at: instVarName put: self asDictionary 
]

{ #category : #'as yet unclassified' }
DataObject >> printString [
	 
	^String 
		streamContents: [ :s | 
			| dict sortedKeys| 
			
			s nextPutAll: 'a'. 
			s nextPutAll: self class name;cr.
			dict := self asDictionary.
			sortedKeys := dict keys sorted. 
			
			sortedKeys
					do: [ :k | | v | 
					v := dict at: k.	
					s  tab;
						nextPutAll: k;
						nextPutAll: v printString;
						cr
			 ]
			
		] limitedTo: 1000
]

{ #category : #'as yet unclassified' }
DataObject >> replicationSpec [

	^{} 
]
