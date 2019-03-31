Class {
	#name : #ImageMeshConnectionModel,
	#superclass : #Object,
	#instVars : [
		'pid',
		'port',
		'isConnected',
		'process',
		'remote',
		'node'
	],
	#category : #'ImageMesh-GUI'
}

{ #category : #accessing }
ImageMeshConnectionModel >> browse [ 
	
	self remote openBrowser.
]

{ #category : #accessing }
ImageMeshConnectionModel >> connect [

	remote := (TlpRemoteIDE connectTo: (TCPAddress localAt: self port)).
	node := self peer evaluate: [ ImageMeshNode current ].
	isConnected := true.
	^ remote
]

{ #category : #accessing }
ImageMeshConnectionModel >> disconnect [ 

	self peer ifNotNil: [ :thePeer | 
		[ self peer close ]  on: Warning do: [ :e | e resume ] ].
	isConnected := false.
]

{ #category : #accessing }
ImageMeshConnectionModel >> hermesPackageDataOf: aPackage [

	| stream  hePackage writer  |

	stream :=  ByteArray new writeStream.

	hePackage := HEPackage for: aPackage.
	writer := HEBinaryReaderWriter new
			stream: stream;
			yourself.
	hePackage writeInto: writer.
	writer flush.
	writer close.

	^ stream contents. 
]

{ #category : #accessing }
ImageMeshConnectionModel >> isConnected [
	^ isConnected
]

{ #category : #accessing }
ImageMeshConnectionModel >> isConnected: anObject [
	isConnected := anObject
]

{ #category : #accessing }
ImageMeshConnectionModel >> isConnectedString [

	^ self isConnected asString
]

{ #category : #accessing }
ImageMeshConnectionModel >> mcPackageDataOf: aPackage [

	| aSnapshot info version stream| 

	aSnapshot := aPackage mcWorkingCopy snapshot.

	info := MCVersionInfo new.
	info instVarNamed: #name put: aPackage name, '-author'.
	version := MCVersion package: (MCPackage new name: aPackage name) info: info snapshot: aSnapshot dependencies: #().

	stream := ByteArray new writeStream.
	MCMczWriter fileOut: version on: stream.
	^ stream contents
]

{ #category : #accessing }
ImageMeshConnectionModel >> node [ 
	
	^ node
]

{ #category : #accessing }
ImageMeshConnectionModel >> openBrowser [ 
	
	self remote openBrowser.
]

{ #category : #accessing }
ImageMeshConnectionModel >> openPlayground [ 
	
	self remote openPlayground.
]

{ #category : #accessing }
ImageMeshConnectionModel >> peer [

	^ self remote ifNotNil: [ :theRemote | theRemote remotePeer ]
]

{ #category : #accessing }
ImageMeshConnectionModel >> pid [
	^ pid
]

{ #category : #accessing }
ImageMeshConnectionModel >> pid: anObject [
	pid := anObject
]

{ #category : #accessing }
ImageMeshConnectionModel >> pidString [

	^ self pid asString
]

{ #category : #accessing }
ImageMeshConnectionModel >> port [
	^ port
]

{ #category : #accessing }
ImageMeshConnectionModel >> port: anObject [
	port := anObject
]

{ #category : #accessing }
ImageMeshConnectionModel >> portString [

	^ self port asString
]

{ #category : #accessing }
ImageMeshConnectionModel >> process [
	^ process
]

{ #category : #accessing }
ImageMeshConnectionModel >> process: anObject [
	process := anObject
]

{ #category : #accessing }
ImageMeshConnectionModel >> remote [
	^ remote
]

{ #category : #accessing }
ImageMeshConnectionModel >> remote: anObject [
	remote := anObject
]
