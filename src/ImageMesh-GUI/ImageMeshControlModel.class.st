Class {
	#name : #ImageMeshControlModel,
	#superclass : #Object,
	#instVars : [
		'imagesCount',
		'vmPath',
		'workingDirectory',
		'imageName',
		'arguments',
		'port'
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
ImageMeshControlModel >> initialize [
	super initialize.
	vmPath := Smalltalk vm directory , '/pharo'.
	workingDirectory := '/home/krivanek/Documents/tele2/pharo-minimal/telepharo'.
	imageName := 'server.image'.
	arguments := {'eval' . '--no-quit' . 'CodeImporter evaluateFileStream: ''/home/krivanek/Documents/tele2/client/Mesh.st'' asFileReference readStream. TlpRemoteUIManager registerOnPort: {1}'}.
	port := 40421.
	imagesCount := 4
]

{ #category : #accessing }
ImageMeshControlModel >> port [
	^ port
]

{ #category : #accessing }
ImageMeshControlModel >> port: anObject [
	port := anObject
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
