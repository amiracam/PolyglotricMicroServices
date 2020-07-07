Class {
	#name : #RdmsFunctionDispatcher,
	#superclass : #RdmsService,
	#category : #'PolyglotricMicroServices-service'
}

{ #category : #services }
RdmsFunctionDispatcher >> connect: aMessage [

	| user response sql |
	
	self logInfo: 'I RdmsService received connect request.'.
	
	user := aMessage at: 'user'.
	
	sql := 
		String new writeStreamDo: [ :s |
		 		s 
					nextPutAll: 'select * from tb_users where user_id= ' ;
					nextPut: $';
					nextPutAll: user;
					nextPut: $';
					contents
				
			].
		
	response := client withConnection: [ :c | c query: sql.].
	
	^response data size = 1 
		ifTrue:[self logInfo: 'User: ' , user , ' successfully authenticated!'.
				  UUIDGenerator new next asString
		]
		ifFalse:[self logInfo: 'User: ' , user , 'not successfully authenticated!'. 
					nil
		].
		
	
		

]

{ #category : #messages }
RdmsFunctionDispatcher >> processFunction: anEvent [
	""
	self halt. 
	client
		withConnection:
			[ :conn | self serverTransactionFactory forEvent: anEvent on: conn ].
]

{ #category : #services }
RdmsFunctionDispatcher >> serverTransactionFactory [
	^ RdmsServerTransaction.
]

{ #category : #services }
RdmsFunctionDispatcher >> transaction: aBlock [

	"here we start a transaction manually and rollback if an exception is thrown"
]
