Class {
	#name : #DeltaWinBinaryWriteStream,
	#superclass : #DeltaWinBinaryPipeStream,
	#category : #Pipes
}

{ #category : #API }
DeltaWinBinaryWriteStream >> << aCollection [

	buffer addAll: aCollection.
	self sendToPipe
]

{ #category : #private }
DeltaWinBinaryWriteStream >> readHead [

	^ buffer first: (buffer size min: self defaultBufferSize)
	
]

{ #category : #private }
DeltaWinBinaryWriteStream >> readHeadToExternalBuffer [

	| data | 
	data := self readHead.
	data withIndexDo: [ :each :index |
		externalBufferAddress byteAt: index put: each ].
	^ data size
]

{ #category : #private }
DeltaWinBinaryWriteStream >> sendToPipe [

	| chunkSize writtenBuffer written |
	
	chunkSize := self readHeadToExternalBuffer.
	writtenBuffer := ExternalAddress allocate: 4.
	writtenBuffer pinInMemory.

	written := 0.	
	[ written < chunkSize] whileTrue: [ 
		self 
			writeFile_hFile: pipe 
			lpBuffer: externalBufferAddress+written 
			nNumberOfBytesToWrite: chunkSize-written 
			lpNumberOfBytesWritten: writtenBuffer 
			lpOverlapped: ExternalAddress null.
		written := written + (writtenBuffer unsignedLongAt: 1).
	].	
	
	writtenBuffer free.
]

{ #category : #private }
DeltaWinBinaryWriteStream >> writeFile_hFile: hFile lpBuffer: lpBuffer nNumberOfBytesToWrite: nNumberOfBytesToWrite lpNumberOfBytesWritten: lpNumberOfBytesWritten lpOverlapped: lpOverlapped [
	^ self ffiCall: #( 
		uint WriteFile(
		  void*       hFile,
		  void*      lpBuffer,
		  uint        nNumberOfBytesToWrite,
		  uint*      lpNumberOfBytesWritten,
		  void* lpOverlapped
		) ) module: DeltaWinKernel32FFI
]
