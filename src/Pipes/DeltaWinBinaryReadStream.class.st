Class {
	#name : #DeltaWinBinaryReadStream,
	#superclass : #DeltaWinBinaryPipeStream,
	#category : #Pipes
}

{ #category : #API }
DeltaWinBinaryReadStream >> atEnd [

	^ self hasData not.

]

{ #category : #initialization }
DeltaWinBinaryReadStream >> byteArrayFrom: externalArray numBytes: numBytes [
	| aByteArray |
	aByteArray := ByteArray new: numBytes.
	1 to: numBytes do: [ :index| 
		| byte |
		byte := externalArray byteAt: index.
		aByteArray at: index put: byte.
	].
	^aByteArray
]

{ #category : #initialization }
DeltaWinBinaryReadStream >> hasData [ 
	
	| availableBuffer available peekOk hasData |
	availableBuffer := ExternalAddress allocate: 4.
	peekOk := self peekNamedPipe_hNamedPipe: pipe
		lpBuffer: ExternalAddress null
		nBufferSize: 0
		lpBytesRead: ExternalAddress null
		lpTotalBytesAvail: availableBuffer
		lpBytesLeftThisMessage: ExternalAddress null.
	available := availableBuffer unsignedLongAt: 1.
	hasData := (peekOk = 1) and: [ available > 0 ].
	availableBuffer free.

	^ hasData
]

{ #category : #initialization }
DeltaWinBinaryReadStream >> peekNamedPipe_hNamedPipe: hNamedPipe lpBuffer: lpBuffer nBufferSize: nBufferSize lpBytesRead: lpBytesRead lpTotalBytesAvail: lpTotalBytesAvail lpBytesLeftThisMessage: lpBytesLeftThisMessage [ 
^ self ffiCall: #( 
uint PeekNamedPipe(
  void*  hNamedPipe,
  void*  lpBuffer,
  uint   nBufferSize,
  uint* lpBytesRead,
  uint* lpTotalBytesAvail,
  uint* lpBytesLeftThisMessage
) ) module: DeltaWinKernel32FFI
]

{ #category : #initialization }
DeltaWinBinaryReadStream >> readFile_hFile: hFile lpBuffer: lpBuffer nNumberOfBytesToRead: nNumberOfBytesToRead lpNumberOfBytesRead: lpNumberOfBytesRead lpOverlapped: lpOverlapped [
	^ self ffiCall: #( 
		uint ReadFile(
		  void*       hFile,
		  void*       lpBuffer,
		  uint        nNumberOfBytesToRead,
		  uint*      lpNumberOfBytesRead,
		  void* lpOverlapped
		) ) module: DeltaWinKernel32FFI
]

{ #category : #initialization }
DeltaWinBinaryReadStream >> readFromPipe [

	| numReadBuffer success numRead bytes |
	
	self hasData ifFalse: [ ^ ByteArray new ].
	
	numReadBuffer := ExternalAddress allocate: 4.
	numReadBuffer pinInMemory.
	
	[	success := self readFile_hFile: pipe
			lpBuffer: externalBufferAddress 
			nNumberOfBytesToRead: self defaultBufferSize
			lpNumberOfBytesRead: numReadBuffer
			lpOverlapped: ExternalAddress null.
					
		numRead := numReadBuffer unsignedLongAt: 1.
		"ended := (success ~= 1) or: [ numRead=0 ]."
		bytes := self byteArrayFrom: externalBufferAddress numBytes: numRead.
		buffer addAll: bytes.
	
		self hasData
	] whileTrue.

	numReadBuffer free.

]

{ #category : #API }
DeltaWinBinaryReadStream >> upToEnd [ 

	self readFromPipe.
	^ (buffer removeFirst: buffer size) asByteArray
]

{ #category : #API }
DeltaWinBinaryReadStream >> upToProcessEnd [

	^ ByteArray streamContents:  [ :anArray | 
		| read |
		[self hasData or: [self closed not]] whileTrue: [ 
		self waitForDataTimeout: 10.
		read := self upToEnd.
		anArray nextPutAll: read. ]].
]

{ #category : #API }
DeltaWinBinaryReadStream >> waitForData [

	[ self hasData not ] whileTrue: [ Processor yield ]

]

{ #category : #API }
DeltaWinBinaryReadStream >> waitForDataTimeout: timeOutInMilliseconds [

	"waits for data with a given time-out. Returns true if the time-out was passed"

	| startingTime timeOutPassed |
	
	startingTime := DateAndTime now asMilliSeconds.
	[ self hasData not and: [ timeOutPassed := (DateAndTime now asMilliSeconds-startingTime >= timeOutInMilliseconds). timeOutPassed not ] ] whileTrue: [ Processor yield ].

	^ timeOutPassed

]
