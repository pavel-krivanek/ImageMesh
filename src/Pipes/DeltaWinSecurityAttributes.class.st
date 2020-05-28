Class {
	#name : #DeltaWinSecurityAttributes,
	#superclass : #FFIExternalStructure,
	#classVars : [
		'OFFSET_BINHERITHANDLE',
		'OFFSET_LPSECURITYDESCRIPTOR',
		'OFFSET_NLENGTH'
	],
	#pools : [
		'OSWSWinTypes'
	],
	#category : #Pipes
}

{ #category : #'field definition' }
DeltaWinSecurityAttributes class >> fieldsDesc [
	"self rebuildFieldAccessors"
	
	^ #(
	DWORD  nLength;
	LPVOID lpSecurityDescriptor;
	int32   bInheritHandle;
	)
]

{ #category : #'accessing structure variables' }
DeltaWinSecurityAttributes >> bInheritHandle [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_BINHERITHANDLE
]

{ #category : #'accessing structure variables' }
DeltaWinSecurityAttributes >> bInheritHandle: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_BINHERITHANDLE put: anObject
]

{ #category : #'accessing structure variables' }
DeltaWinSecurityAttributes >> initialize [ 
super initialize.
OSWSWinProcessLibrary clear: self

]

{ #category : #'accessing structure variables' }
DeltaWinSecurityAttributes >> lpSecurityDescriptor [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_LPSECURITYDESCRIPTOR) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
DeltaWinSecurityAttributes >> lpSecurityDescriptor: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_LPSECURITYDESCRIPTOR put: anObject getHandle.
]

{ #category : #'accessing structure variables' }
DeltaWinSecurityAttributes >> nLength [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_NLENGTH
]

{ #category : #'accessing structure variables' }
DeltaWinSecurityAttributes >> nLength: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_NLENGTH put: anObject
]
