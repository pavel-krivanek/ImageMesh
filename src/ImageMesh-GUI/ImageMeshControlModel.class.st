Class {
	#name : #ImageMeshControlModel,
	#superclass : #Object,
	#instVars : [
		'imagesCount',
		'vmPath',
		'workingDirectory',
		'imageName',
		'arguments',
		'processes'
	],
	#category : #'ImageMesh-GUI'
}

{ #category : #accessing }
ImageMeshControlModel >> arguments [
	^ arguments
]

{ #category : #accessing }
ImageMeshControlModel >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
ImageMeshControlModel >> imageName [
	^ imageName
]

{ #category : #accessing }
ImageMeshControlModel >> imageName: anObject [
	imageName := anObject
]

{ #category : #accessing }
ImageMeshControlModel >> imagesCount [
	^ imagesCount
]

{ #category : #accessing }
ImageMeshControlModel >> imagesCount: anObject [
	imagesCount := anObject
]

{ #category : #accessing }
ImageMeshControlModel >> vmPath [
	^ vmPath
]

{ #category : #accessing }
ImageMeshControlModel >> vmPath: anObject [
	vmPath := anObject
]

{ #category : #accessing }
ImageMeshControlModel >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
ImageMeshControlModel >> workingDirectory: anObject [
	workingDirectory := anObject
]
