Class {
	#name : #API,
	#superclass : #Object,
	#instVars : [
		'response',
		'format',
		'zipped',
		'sessionId',
		'databaseBroker'
	],
	#classVars : [
		'Source'
	],
	#category : #PolyglotricMicroServices
}

{ #category : #'reflective operations' }
API >> doesNotUnderstand: aMessage [

	"sets up forwarding to the API source"
	
	self source ifNil: [^ self error: 'API source has not yet been registered !' ].
	^self source perform: aMessage selector withArguments: aMessage arguments
	
	
]

{ #category : #processing }
API >> formatOutput [

	self perform format,'Format' with: self response
]

{ #category : #initialization }
API >> initialize [ 

	format := 'json'.
	zipped := false.
]

{ #category : #formatting }
API >> jsonFormat: dataResponse [

	| row hash |
	
	"todo: dataResponse can be an array or a string or a dict , review design"
	
	(dataResponse isKindOf: Dictionary)
		ifTrue: [ 
			dataResponse 
				at: #data ifAbsentPut: #();
				at: #cols ifAbsentPut: #().
				
			(dataResponse includeKey: #error_code )
				ifTrue: [ 
					row := OrderedCollection new.
					row 
						<< (self translateErrorCode: dataResponse);
						<< (dataResponse at: #error_msg).
					(dataResponse at: #data ) << row.
					(dataResponse at: #cols) << 'Error #'; << 'Description'
				 ]
				ifFalse:[
					dataResponse 
						at: #error_code put: 0;
						at: #error_msg put: '';
						at: #sql_state put: 0
				].
			dataResponse toJson .  
				
		 ]  
	ifFalse:[
		hash := Dictionary new.
		hash at: #data put: dataResponse .
		hash toJson .
	]
]

{ #category : #processing }
API >> performer [

	^ self class name lowercase 
]

{ #category : #playing }
API >> play [ 
	
	self subclassResponsibility 
]

{ #category : #processing }
API >> playOn: application [ 
	
	self play 
]

{ #category : #processing }
API >> processOn: application [ 

	application perform: self performer with: self.
	self logInfo: 'API is: ' , self class name asString.
	
	^ self formatOutput
]

{ #category : #initialization }
API >> register: aSource [

	Source := aSource 
]

{ #category : #accessing }
API >> source [ 

	^Source 
]

{ #category : #initialization }
API >> translateErrorCode: dictionary [ 

	"for now dont translate error which should be delegated to the session object"
	
	^ dictionary at: #error_code
]
