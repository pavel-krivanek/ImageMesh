Class {
	#name : #BaselineOfImageMesh,
	#superclass : #BaselineOf,
	#category : #BaselineOfImageMesh
}

{ #category : #baselines }
BaselineOfImageMesh >> baseline: spec [
	<baseline>
	spec
		for: #pharo
		do: [ 
			spec baseline: 'TelePharo' with: [
				spec
					repository: 'github://pharo-ide/TelePharo';
					loads: 'Client' ].		
			spec baseline: 'OSSubprocess' with: [
				spec
					repository: 'github://pharo-contributions/OSSubprocess'. ].		
			spec baseline: 'TaskIt' with: [
				spec
					repository: 'github://pavel-krivanek/taskit:49-baseline-for-P8'. ].		
			spec baseline: 'Hermes' with: [
				spec
					repository: 'github://tesonep/hermes';
					loads: 'core' ].		

			spec package: 'ImageMesh-Node' with: [ spec requires: #()].
			spec package: 'ImageMesh-GUI' with: [ spec requires: #(TelePharo OSSubprocess TaskIt Hermes)].
				
		spec
			group: 'node'
			with: #('ImageMesh-Node').
		spec
			group: 'default'
			with: #(TelePharo OSSubprocess TaskIt Hermes 'ImageMesh-Node' 'ImageMesh-GUI').
	]
]
