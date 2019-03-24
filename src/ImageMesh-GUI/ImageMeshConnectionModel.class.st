Class {
	#name : #ImageMeshConnectionModel,
	#superclass : #Object,
	#instVars : [
		'pid',
		'port',
		'isConnected'
	],
	#category : #'ImageMesh-GUI'
}

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
