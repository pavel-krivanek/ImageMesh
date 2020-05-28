"
Should not be a subclass of DeltaError because these should not be caught by the library.
The application gave a bad argument or a similar situation in which we want a debugger to open instead of it being handled somehow.
"
Class {
	#name : #DeltaUsageError,
	#superclass : #Exception,
	#instVars : [
		'situation'
	],
	#category : #Pipes
}

{ #category : #situations }
DeltaUsageError class >> raiseSignal: msg [
self new messageText: msg; raiseSignal
]

{ #category : #accessing }
DeltaUsageError >> defaultAction [
UnhandledError signalForException: self
]

{ #category : #accessing }
DeltaUsageError >> raiseSignal [
self signal
]

{ #category : #accessing }
DeltaUsageError >> situation [

	^situation
]

{ #category : #accessing }
DeltaUsageError >> situation: a [

	situation := a
]
