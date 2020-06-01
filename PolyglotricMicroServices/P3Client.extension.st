Extension { #name : #P3Client }

{ #category : #'*PolyglotricMicroServices' }
P3Client >> beginTransaction [

	self execute: 'BEGIN'
]

{ #category : #'*PolyglotricMicroServices' }
P3Client >> commitTransaction [

	self execute: 'COMMIT'
]

{ #category : #'*PolyglotricMicroServices' }
P3Client >> inTransaction: closure [
	self beginTransaction.
	[ closure value: self.
	self commitTransaction
	]
		on: P3Error
		do: [ :ex | 
			self rollbackTransaction .
			self error: 'Transaction Aborted.' ].
]

{ #category : #'*PolyglotricMicroServices' }
P3Client >> rollbackTransaction [

	self execute: 'ROLLBACK'
]
