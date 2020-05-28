"
Base error class for this library.

Instance Variables:

	situation	<>	token that can be used by the server to tell the client where in the code the error originally occured. it is the same situation-token as in the throw-error-on-purpose system
"
Class {
	#name : #DeltaError,
	#superclass : #Error,
	#instVars : [
		'situation',
		'timestamp',
		'exception',
		'deltaSystem'
	],
	#category : #Pipes
}

{ #category : #situations }
DeltaError class >> ensuringDirAtPathOccupiedByFile [

	^#ensuringDirAtPathOccupiedByFile
]

{ #category : #situations }
DeltaError class >> ensuringDirectory [

	^#ensuringDirectory
]

{ #category : #situations }
DeltaError class >> errorUploadDir [
	"- caller wanted to upload a file instead of this dir?
	- or caller should have used update-api (being aware what it does)"

	^#errorUploadDir
]

{ #category : #situations }
DeltaError class >> errorUploadFileThatDoesNotExist [

	^#errorUploadFileThatDoesNotExist
]

{ #category : #situations }
DeltaError class >> filesizeOfFileThatDoesNotExist [

	^#filesizeOfFileThatDoesNotExist
]

{ #category : #'instance creation' }
DeltaError class >> new [

	^self basicNew initialize
]

{ #category : #situations }
DeltaError class >> raiseSignal: msg [
self new messageText: msg; raiseSignal
]

{ #category : #exceptiondescription }
DeltaError >> defaultAction [
UnhandledError signalForException: self
]

{ #category : #accessing }
DeltaError >> deltaSystem [

	^deltaSystem
]

{ #category : #accessing }
DeltaError >> deltaSystem: a [

	deltaSystem := a
]

{ #category : #accessing }
DeltaError >> exception [

	^exception
]

{ #category : #accessing }
DeltaError >> exception: ex [

	exception := ex
]

{ #category : #exceptiondescription }
DeltaError >> raiseSignal [
self signal
]

{ #category : #accessing }
DeltaError >> situation [

	^situation
]

{ #category : #accessing }
DeltaError >> situation: a [

	situation := a
]
