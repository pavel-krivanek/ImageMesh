Class {
	#name : #DeltaWinKernel32FFI,
	#superclass : #FFILibrary,
	#classInstVars : [
		'processHandle'
	],
	#category : #Pipes
}

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> asUtf16WithTerminator: utf8 [
| converter |
converter := UTF16TextConverter new.
converter useLittleEndian: true.
^(utf8 convertToWithConverter: converter) asByteArray, #[0 0].
]

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> closeHandle: handle [
^ self ffiCall: #( uint CloseHandle (void* handle) ) module: self

]

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> createChildProcess: executableFireReference arguments: arguments childStderrWr: childStderrWr childStdoutWr: childStdoutWr childStdinRd: childStdinRd [
	|  threadHandle commandLineUtf16 exePath putIntoCmdline processInfo startupInfo success |
	exePath := executableFireReference asFileReference fullName.
	putIntoCmdline := arguments 
		ifNotEmpty: [exePath, ' ', (arguments joinUsing: ' ')]
		ifEmpty: [ exePath ].
	commandLineUtf16 := DeltaWinKernel32FFI asUtf16WithTerminator: putIntoCmdline.
	commandLineUtf16 pinInMemory. "must be writable during CreateProcess"
	processInfo := self makeProcessInfo.
	startupInfo := self makeStartupInfo2.
	startupInfo hStdError: childStderrWr.
	startupInfo hStdInput: childStdinRd.
	startupInfo hStdOutput: childStdoutWr.
	startupInfo dwFlags: 256.
	success := self createProcessW: ExternalAddress null
		cmdLine: commandLineUtf16
		pAttrs: ExternalAddress null
		tAttrs: ExternalAddress null
		inherit: 1
		cFlags: 0
		env: ExternalAddress null
		cwd: ExternalAddress null
		sInfo: startupInfo
		pInfo: processInfo.
	success = 1 ifFalse: [ ^ nil ].
	self closeHandle: childStderrWr.
	self closeHandle: childStdoutWr.
	self closeHandle: childStdinRd.
	processHandle := processInfo hProcess.
	threadHandle := processInfo hThread.
	^{ processHandle . threadHandle}
]

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> createPipe_hReadPipe: hReadPipe hWritePipe: hWritePipe lpPipeAttributes: lpPipeAttributes nSize: nSize [
^ self ffiCall: #( 
int32 CreatePipe(
  void*               hReadPipe,
  void*               hWritePipe,
  DeltaWinSecurityAttributes* lpPipeAttributes,
  uint32                 nSize
) ) module: self
]

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> createProcessW: appName cmdLine: cmdLine pAttrs: pAttrs tAttrs: tAttrs inherit: inherit cFlags: cFlags env: env cwd: cwd sInfo: sInfo pInfo: pInfo [
^ self ffiCall: #( uint CreateProcessW (
	void* appName,
	void* cmdLine, 
	void* pAttrs,
	void* tAttrs,
	uint inherit,
	uint cFlags,
	void* env,
	void* cwd,
	OSWSStartupInfoW* sInfo,
	OSWSProcessInformation* pInfo
	) ) module: self
]

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> createReadWriteHandles: securityAttributes [ 
|readBuffer writeBuffer readHandle writeHandle|
readBuffer := ExternalAddress allocate: 8.
readBuffer unsignedLongLongAt: 1 put: 0.
writeBuffer := ExternalAddress allocate: 8.
writeBuffer unsignedLongLongAt: 1 put: 0.
self createPipe_hReadPipe: readBuffer hWritePipe: writeBuffer lpPipeAttributes: securityAttributes nSize: 0.
readHandle := readBuffer pointerAt: 1.
readHandle = 0 ifTrue: [ self halt ].
writeHandle := writeBuffer pointerAt: 1.
writeHandle = 0 ifTrue: [ self halt ].
readBuffer free.
writeBuffer free.
^{readHandle . writeHandle}
]

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> delProcess: process [
self closeHandle: (process at: 1).
self closeHandle: (process at: 2).

]

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> getExitCodeProcess: hProcess [
|buf ec|
buf := ExternalAddress allocate: 4.
buf unsignedLongAt: 1 put: 0.
self getExitCodeProcess: hProcess into: buf.
ec := buf unsignedLongAt: 1.
^ec
]

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> getExitCodeProcess: hProcess into: into [
^ self ffiCall: #( uint GetExitCodeProcess (
	void* hProcess,
	uint32* into) ) module: self

]

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> makeProcessInfo [
	| processInfo |
	processInfo := OSWSProcessInformation externalNew.
	^processInfo.

]

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> makeStartupInfo2 [
	| startupInfo |
	startupInfo := OSWSStartupInfoW externalNew.
	startupInfo cb: startupInfo class structureSize.
	^startupInfo

]

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> peekNamedPipe_hNamedPipe: hNamedPipe lpBuffer: lpBuffer nBufferSize: nBufferSize lpBytesRead: lpBytesRead lpTotalBytesAvail: lpTotalBytesAvail lpBytesLeftThisMessage: lpBytesLeftThisMessage [ 
^ self ffiCall: #( 
uint PeekNamedPipe(
  void*  hNamedPipe,
  void*  lpBuffer,
  uint   nBufferSize,
  uint* lpBytesRead,
  uint* lpTotalBytesAvail,
  uint* lpBytesLeftThisMessage
) ) module: self
]

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> readFile_hFile: hFile lpBuffer: lpBuffer nNumberOfBytesToRead: nNumberOfBytesToRead lpNumberOfBytesRead: lpNumberOfBytesRead lpOverlapped: lpOverlapped [
^ self ffiCall: #( 
uint ReadFile(
  void*       hFile,
  void*       lpBuffer,
  uint        nNumberOfBytesToRead,
  uint*      lpNumberOfBytesRead,
  void* lpOverlapped
) ) module: self
]

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> removeDirectoryW: pathW [
^ self ffiCall: #( int RemoveDirectoryW (void* pathW) ) module: self

]

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> setHandleInformation_hObject: hObject dwMask: dwMask dwFlags: dwFlags [
^ self ffiCall: #( 
uint SetHandleInformation(
  void* hObject,
  uint  dwMask,
  uint  dwFlags
) ) module: self
]

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> unblockPipe: pipe [ 
|availableBuffer available peekOk shouldUnblock|
availableBuffer := ExternalAddress allocate: 4.
peekOk := self peekNamedPipe_hNamedPipe: pipe
	lpBuffer: ExternalAddress null
	nBufferSize: 0
	lpBytesRead: ExternalAddress null
	lpTotalBytesAvail: availableBuffer
	lpBytesLeftThisMessage: ExternalAddress null.
available := availableBuffer unsignedLongAt: 1.
shouldUnblock := peekOk=0 | (available > 0).
availableBuffer free.

^shouldUnblock
]

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> waitForProcess: process [
self waitForSingleObject: (process at: 1) millis:  4294967295
]

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> waitForSingleObject: handle millis: millis [
	^ self ffiCall: #( uint WaitForSingleObject (
		void* handle,
		uint millis) ) module: self

]

{ #category : #'as yet unclassified' }
DeltaWinKernel32FFI class >> writeFile_hFile: hFile lpBuffer: lpBuffer nNumberOfBytesToWrite: nNumberOfBytesToWrite lpNumberOfBytesWritten: lpNumberOfBytesWritten lpOverlapped: lpOverlapped [
^ self ffiCall: #( 
uint WriteFile(
  void*       hFile,
  void*      lpBuffer,
  uint        nNumberOfBytesToWrite,
  uint*      lpNumberOfBytesWritten,
  void* lpOverlapped
) ) module: self
]

{ #category : #'accessing platform' }
DeltaWinKernel32FFI >> unixModuleName [
DeltaUsageError new raiseSignal
]

{ #category : #'accessing platform' }
DeltaWinKernel32FFI >> win32ModuleName [
^'kernel32.dll'
]
