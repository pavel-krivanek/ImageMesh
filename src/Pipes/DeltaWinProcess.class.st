"
command := 'Pharo.exe'.
	arguments := #('missing.image').

	aProcess := DeltaWinProcess new
		programReference: command asFileReference;
		arguments: arguments;
		yourself.
	
	aProcess open.

	stdout := aProcess stdout upToProcessEnd utf8Decoded.
	stderr := aProcess stderr upToProcessEnd utf8Decoded.

	aProcess detach.
"
Class {
	#name : #DeltaWinProcess,
	#superclass : #Object,
	#instVars : [
		'programReference',
		'arguments',
		'stdin',
		'stdout',
		'stderr',
		'securityAttributes',
		'childOut',
		'childErr',
		'childIn',
		'process',
		'writeStream',
		'outReadStream',
		'errReadStream'
	],
	#category : #Pipes
}

{ #category : #examples }
DeltaWinProcess class >> example [

	<example>
	
	| command arguments aProcess stdout stderr |
	command := 'Pharo.exe'.
	arguments := #('missing.image').

	aProcess := DeltaWinProcess new
		programReference: command asFileReference;
		arguments: arguments;
		yourself.
	
	aProcess open.

	stdout := aProcess stdout upToProcessEnd utf8Decoded.
	stderr := aProcess stderr upToProcessEnd utf8Decoded.

	aProcess detach.
	
	{ stdout. stderr } inspect.
]

{ #category : #accessing }
DeltaWinProcess >> arguments [
	^ arguments
]

{ #category : #accessing }
DeltaWinProcess >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
DeltaWinProcess >> childErr [
	^ childErr
]

{ #category : #'instance creation' }
DeltaWinProcess >> closeStreams [

	self library closeHandle: (childIn at: 2).
	self library closeHandle: (childOut at: 1).
	self library closeHandle: (childErr at: 1).

	stdin := stdout := stderr := nil.
]

{ #category : #'instance creation' }
DeltaWinProcess >> detach [ 

	self closeStreams.
	self library waitForProcess: process.
	self library delProcess: process.
]

{ #category : #'instance creation' }
DeltaWinProcess >> handle [ 

	^ process first
]

{ #category : #'instance creation' }
DeltaWinProcess >> initialize [

	super initialize.
	
	arguments := Array new.
]

{ #category : #'instance creation' }
DeltaWinProcess >> library [

	^ DeltaWinKernel32FFI.

]

{ #category : #'instance creation' }
DeltaWinProcess >> open [ 
	
	securityAttributes := DeltaWinSecurityAttributes externalNew.
	securityAttributes nLength: (securityAttributes class structureSize).
	securityAttributes bInheritHandle: 1.

	self openStreams.
	
	process := self library createChildProcess: programReference arguments: arguments childStderrWr: (childErr at: 2) childStdoutWr: (childOut at: 2) childStdinRd: (childIn at: 1).
	

]

{ #category : #'instance creation' }
DeltaWinProcess >> openStreams [

	childOut := self library createReadWriteHandles: securityAttributes.
	childErr := self library createReadWriteHandles: securityAttributes.
	childIn := self library createReadWriteHandles: securityAttributes.
	self library setHandleInformation_hObject: (childOut at: 1) dwMask: 1 dwFlags: 0.
	self library setHandleInformation_hObject: (childErr at: 1) dwMask: 1 dwFlags: 0.
	self library setHandleInformation_hObject: (childIn at: 2) dwMask: 1 dwFlags: 0.

	stdin := DeltaWinBinaryWriteStream new pipe: (childIn at: 2) ; process: self.
	stdout := DeltaWinBinaryReadStream new pipe: (childOut at: 1) ; process: self.
	stderr := DeltaWinBinaryReadStream new pipe: (childErr at: 1) ; process: self.

]

{ #category : #accessing }
DeltaWinProcess >> outReadStream [
	^ outReadStream
]

{ #category : #accessing }
DeltaWinProcess >> programReference [
	^ programReference
]

{ #category : #accessing }
DeltaWinProcess >> programReference: anObject [
	programReference := anObject
]

{ #category : #accessing }
DeltaWinProcess >> stderr [
	^ stderr
]

{ #category : #accessing }
DeltaWinProcess >> stdin [
	^ stdin
]

{ #category : #accessing }
DeltaWinProcess >> stdout [
	^ stdout
]
