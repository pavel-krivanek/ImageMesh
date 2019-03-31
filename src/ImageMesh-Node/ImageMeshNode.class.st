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
