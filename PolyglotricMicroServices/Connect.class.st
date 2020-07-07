Class {
	#name : #Connect,
	#superclass : #API,
	#instVars : [
		'url',
		'user',
		'pass',
		'ip'
	],
	#category : #'PolyglotricMicroServices-service'
}

{ #category : #'instance creation' }
Connect class >> user: aUser pass: aPass ip: anIp [

	^(self basicNew)
		user: aUser;
		pass: aPass;
		ip: anIp ;
		initialize;
		yourself 
]

{ #category : #initialization }
Connect >> inititalize [

	super initialize .
	url  := self connectionStringFor: user  andPassword: pass  

]

{ #category : #accessing }
Connect >> ip [
	^ ip
]

{ #category : #accessing }
Connect >> ip: anObject [
	ip := anObject
]

{ #category : #accessing }
Connect >> pass [
	^ pass
]

{ #category : #accessing }
Connect >> pass: anObject [
	pass := anObject
]

{ #category : #playing }
Connect >> play [ 
	"Check if user exists in DB"
	(self testIfValidUser)
		ifTrue:[
			self register.	
		]
		ifFalse:[self error: 'Could not authenticate user: ' , url]
]

{ #category : #accessing }
Connect >> url [
	^ url
]

{ #category : #accessing }
Connect >> url: anObject [
	url := anObject
]

{ #category : #accessing }
Connect >> user [
	^ user
]

{ #category : #accessing }
Connect >> user: anObject [
	user := anObject
]
