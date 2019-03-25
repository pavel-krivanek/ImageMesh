Class {
	#name : #Mesh,
	#superclass : #Object,
	#instVars : [
		'peers',
		'remoteMeshes',
		'index'
	],
	#classVars : [
		'Current'
	],
	#category : #'ImageMesh-GUI'
}

{ #category : #'as yet unclassified' }
Mesh >> connectTo2: remoteIndex [

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

{ #category : #'as yet unclassified' }
Mesh >> connectTo: remoteIndex [

	| peer f |
	
	Transcript show: index; show: ' is connecting...'; cr.
[ 	
	peer := (SeamlessNetwork someInstance) remotePeerAt: (TCPAddress ip: #[127 0 0 1] port: 40420+remoteIndex).
	peers at: remoteIndex put: peer.
	
f := [
	peer evaluate: [ 
		Mesh current remoteMeshes at: self index put: self. 
		self remoteMeshes at: remoteIndex put: Mesh current ].
	] future.
f onSuccessDo: [ :e | 
	Transcript show: 'remote mesh installed in '; show: remoteIndex; show: ' from: '; show: self index; cr. ].

] on: Error do: [ :err | Transcript show: err; cr. thisContext stack logCr.]
]

{ #category : #'as yet unclassified' }
Mesh >> index [
	^ index
]

{ #category : #'as yet unclassified' }
Mesh >> index: anObject [
	index := anObject
]

{ #category : #'as yet unclassified' }
Mesh >> initialize [ 

	super initialize.
	
	peers := Dictionary new.
	remoteMeshes := Dictionary new.
]

{ #category : #'as yet unclassified' }
Mesh >> peers [
	^ peers
]
