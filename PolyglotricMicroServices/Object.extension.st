Extension { #name : #Object }

{ #category : #'*PolyglotricMicroServices' }
Object >> persistOn: dict useName: instVarName [ 

	dict at: instVarName put: self.
]
