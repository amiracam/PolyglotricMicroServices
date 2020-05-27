Class {
	#name : #Logger,
	#superclass : #Object,
	#instVars : [
		'filename',
		'homeDir',
		'date',
		'todaysFolder',
		'logFile'
	],
	#category : #PolyglotricMicroServices
}

{ #category : #'instance creation' }
Logger class >> on: path [

	^ self new path: path
]

{ #category : #accessing }
Logger >> filename [
	^ filename
]

{ #category : #accessing }
Logger >> filename: anObject [
	filename := anObject
]

{ #category : #accessing }
Logger >> homeDir [
	^ homeDir
]

{ #category : #accessing }
Logger >> homeDir: anObject [
	homeDir := anObject
]

{ #category : #writing }
Logger >> info: anObject [
	self
		write:
			(String new writeStream
				nextPutAll: '[INFO]';
				tab;
				nextPutAll: anObject asString;
				contents).
]

{ #category : #private }
Logger >> logDir [
	
	
	todaysFolder := Date today printFormat: #(3 2 1 $- 1 1 2).

	^ String new
		writeStreamDo: [ :s | 
			s
				nextPutAll: homeDir;
				nextPut: $/;
				nextPutAll: todaysFolder;
				nextPut: $/;
				contents
			].
]

{ #category : #private }
Logger >> logFile [
	
	
	^logFile 
		ifNil:[
			| fRef |
			logFile := self logDir , '/', filename, '.log'.
			(fRef := logFile asFileReference) ensureCreateFile.
			fRef exists ifFalse: [ self error: 'Unable to create log file for path: ', logFile].
			logFile	
		]
]

{ #category : #writing }
Logger >> write: aString [
	| reference |
	
	reference := self logFile asFileReference.
	
	reference
		writeStreamDo: [ :s | 
			
			s setToEnd.
			
			s
				nextPutAll: Time now asString;
				tab;
				nextPutAll: aString;
				cr;
				flush
			].
]
