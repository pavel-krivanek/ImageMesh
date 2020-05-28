Class {
	#name : #DeltaWinBinaryPipeStream,
	#superclass : #Object,
	#instVars : [
		'externalBuffer',
		'pipe',
		'buffer',
		'externalBufferAddress',
		'process'
	],
	#category : #Pipes
}

{ #category : #'instance creation' }
DeltaWinBinaryPipeStream class >> on: aPipe [

	^ self new 
		pipe: aPipe;
		yourself
]

{ #category : #accessing }
DeltaWinBinaryPipeStream >> closed [ 

	^ self processClosed
]

{ #category : #accessing }
DeltaWinBinaryPipeStream >> defaultBufferSize [

	^ 1024
]

{ #category : #initialization }
DeltaWinBinaryPipeStream >> finalize [

	externalBufferAddress ifNotNil: #free
]

{ #category : #initialization }
DeltaWinBinaryPipeStream >> initialize [ 

	super initialize.
	externalBufferAddress := ExternalAddress allocate: 1000.
	externalBuffer pinInMemory.
	buffer := OrderedCollection new.
	
	self class finalizationRegistry add: self.
	
]

{ #category : #accessing }
DeltaWinBinaryPipeStream >> pipe [
	^ pipe
]

{ #category : #accessing }
DeltaWinBinaryPipeStream >> pipe: anObject [
	pipe := anObject
]

{ #category : #accessing }
DeltaWinBinaryPipeStream >> process [
	^ process
]

{ #category : #accessing }
DeltaWinBinaryPipeStream >> process: anObject [
	process := anObject
]

{ #category : #accessing }
DeltaWinBinaryPipeStream >> processClosed [

	^ (DeltaWinKernel32FFI getExitCodeProcess: process handle) ~= 259
]
