"
[remotes do: #disconnect ] on: Warning do: [ :e | e resume ].
TKTCommonQueueWorkerPool allInstancesDo: #reset.

workersCount := 4.

remotes := (1 to: workersCount) collect: [ :i | TlpRemoteIDE connectTo: (TCPAddress localAt: 40420+i) ].
workers := remotes collect: [ :each | each remotePeer ].

col := 1 to: workersCount.
combinations := Set new.
col allPairsDo: [ :a :b | (a = b) ifFalse: [ combinations add: {a. b} asSet ] ].
combinations size.

combinations := combinations collect: [:e | e asArray] as: Array.

futures := workers withIndexCollect: [ :worker :index | 
		| f  | 
		f := [ worker evaluate: [
			| peers myPeers myCombinations |
			
			peers := 	SmalltalkImage current at: #connections ifAbsentPut: [ Dictionary new ].
			myCombinations := combinations select: [ :e | e first = index ] thenCollect: #second.
			myCombinations do: [ :remoteIndex | 
				Mesh current connectTo: remoteIndex.
				 ] ].				
		] future.
		f onSuccessDo: [ :e | Transcript show: 'worker '; show: index; show: ' finished: '; show: e; cr. ] ].

workers collect: [ :worker | worker evaluate: [ Mesh current peers size ] ].

"
Class {
	#name : #ImageMeshNode,
	#superclass : #Object,
	#instVars : [
		'peers',
		'remoteMeshes',
		'index'
	],
	#classVars : [
		'Current'
	],
	#category : #'ImageMesh-Node'
}

{ #category : #'class initialization' }
ImageMeshNode class >> current [ 
	
	^ Current
]

{ #category : #'class initialization' }
ImageMeshNode class >> initialize [ 

	Smalltalk vm maxExternalSemaphoresSilently: 5000.
	"
	TKTConfiguration profile: TKTProfile production."

	Current := self new.
]

{ #category : #accessing }
ImageMeshNode >> connectTo2: remoteIndex [

	| peer f |
	
	Transcript show: index; show: ' is connecting...'; cr.
[ 	
	peer := (SeamlessNetwork someInstance) remotePeerAt: (TCPAddress ip: #[127 0 0 1] port: 40420+remoteIndex).
	peers at: remoteIndex put: peer.
	
f := [
	100 factorial.
	"peer evaluate: [ Mesh current remoteMeshes at: self index put: self ]."
	] future.
f onSuccessDo: [ :e | Transcript show: 'remote mesh installed in '; show: remoteIndex; show: ' from: '; show: self index; cr. ].

] on: Error do: [ :err | Transcript show: err; cr. ]
]

{ #category : #accessing }
ImageMeshNode >> connectTo3: remoteIndex [

	| peer f |
	
	Transcript show: index; show: ' is connecting...'; cr.
[ 	
	peer := (SeamlessNetwork someInstance) remotePeerAt: (TCPAddress ip: #[127 0 0 1] port: 40420+remoteIndex).
	peers at: remoteIndex put: peer.
	
peer evaluate: [  ].
] on: Error do: [ :err | Transcript show: err; cr. ]
]

{ #category : #accessing }
ImageMeshNode >> connectTo: remoteIndex [

	| peer f |
	
	Transcript show: index; show: ' is connecting...'; cr.
[ 	
	peer := (SeamlessNetwork someInstance) remotePeerAt: (TCPAddress ip: #[127 0 0 1] port: 40420+remoteIndex).
	peers at: remoteIndex put: peer.
	
f := [
	peer evaluate: [ 
		ImageMeshNode current remoteMeshes at: self index put: self. 
		self remoteMeshes at: remoteIndex put: ImageMeshNode current ].
	] future.
f onSuccessDo: [ :e | 
	Transcript show: 'remote mesh installed in '; show: remoteIndex; show: ' from: '; show: self index; cr. ].

] on: Error do: [ :err | Transcript show: err; cr. thisContext stack logCr.]
]

{ #category : #'as yet unclassified' }
ImageMeshNode >> extension [ 

	 ^ 42
]

{ #category : #'as yet unclassified' }
ImageMeshNode >> hermessInstallPackage: packageData [

	| reader readPackage installer |
	installer := HEExtendedInstaller new.
	reader := HEBinaryReader new
		stream: packageData readStream;
		yourself.
	readPackage := HEPackage readFrom: reader.
	installer installPackage: readPackage

]

{ #category : #accessing }
ImageMeshNode >> index [
	^ index
]

{ #category : #accessing }
ImageMeshNode >> index: anObject [
	index := anObject
]

{ #category : #initialization }
ImageMeshNode >> initialize [ 

	super initialize.
	
	peers := Dictionary new.
	remoteMeshes := Dictionary new.
]

{ #category : #'as yet unclassified' }
ImageMeshNode >> mcInstallPackage: packageData [

	| reader f ref |
	
	"for some unknown reason the minimal image has issues with reading 
	of the data directly. We use a memory filesystem as a workaround"
	
	ref := (FileSystem memory / 'mcPackageData').
	ref ensureDelete.
	f:= ref binaryWriteStream nextPutAll: packageData.
	f flush; close.
	
	reader := MCMczReader on:  ref binaryReadStream .
	reader snapshot install.

]

{ #category : #accessing }
ImageMeshNode >> peers [
	^ peers
]

{ #category : #accessing }
ImageMeshNode >> peers: anObject [
	peers := anObject
]

{ #category : #accessing }
ImageMeshNode >> ping [

	Transcript show: 'Image '; show: self index; show: 'pinging!'.
]

{ #category : #accessing }
ImageMeshNode >> remoteMeshes [
	^ remoteMeshes
]

{ #category : #accessing }
ImageMeshNode >> remoteMeshes: anObject [
	remoteMeshes := anObject
]
