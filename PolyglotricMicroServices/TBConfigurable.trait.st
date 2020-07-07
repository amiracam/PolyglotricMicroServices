"
Configuration specific to Tradeblazer but which depends on overriding Trait Configurable >> #postLoadConfiguration 

   
"
Trait {
	#name : #TBConfigurable,
	#instVars : [
		'appConfiguration'
	],
	#category : #'PolyglotricMicroServices-traits'
}

{ #category : #initialization }
TBConfigurable >> externalConfigPath [
	^ self home , '/../environ/', self inst ,'.ct'
]

{ #category : #initialization }
TBConfigurable >> home [ 

	^ Smalltalk os environment at: 'TB_HOME'
]

{ #category : #initialization }
TBConfigurable >> inst [ 

	^ Smalltalk os environment at: 'TB_INST'
]

{ #category : #initialization }
TBConfigurable >> loadExternalConfig [

	appConfiguration := PropertiesReader readFrom: self externalConfigPath 
]

{ #category : #running }
TBConfigurable >> postLoadConfiguration [

	self loadExternalConfig .

	
]
