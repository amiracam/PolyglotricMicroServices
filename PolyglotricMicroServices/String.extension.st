Extension { #name : #String }

{ #category : #'*PolyglotricMicroServices' }
String >> asJson [
	^ NeoJSONReader fromString: self.
]
