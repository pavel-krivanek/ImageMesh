Class {
	#name : #ImageMeshConnectionModel,
	#superclass : #Object,
	#instVars : [
		'pid',
		'port',
		'isConnected',
		'process',
		'remote'
	],
	#category : #'ImageMesh-GUI'
}

{ #category : #accessing }
ImageMeshConnectionModel >> connect [

	remote := (TlpRemoteIDE connectTo: (TCPAddress localAt: self port)).
	isConnected := true.
	^ remote
]

{ #category : #accessing }
ImageMeshConnectionModel >> disconnect [ 

	self peer ifNotNil: [ :thePeer | 
		[ self peer disconnect ]  on: Warning do: [ :e | e resume ] ].
	isConnected := false.
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
