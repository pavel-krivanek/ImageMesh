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
					repository: 'github://pavel-krivanek/TelePharo:49-baseline-for-P8'. ].		
			spec package: 'ImageMesh-GUI'.		]
]
