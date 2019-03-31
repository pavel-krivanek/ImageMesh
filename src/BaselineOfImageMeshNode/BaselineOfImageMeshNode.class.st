Class {
	#name : #BaselineOfImageMeshNode,
	#superclass : #BaselineOf,
	#category : #BaselineOfImageMeshNode
}

{ #category : #baselines }
BaselineOfImageMeshNode >> baseline: spec [
	<baseline>
	spec
		for: #pharo
		do: [ 
			spec package: 'ImageMesh-Node'
		]
]
