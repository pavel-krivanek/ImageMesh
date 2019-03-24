Class {
	#name : #ImageMeshGUI,
	#superclass : #ComposablePresenter,
	#instVars : [
		'vmPathInput',
		'imageDirectoryInput',
		'imageNameInput',
		'imagesCountInput',
		'portInput',
		'startButton',
		'connectButton',
		'imagesTable'
	],
	#category : #'ImageMesh-GUI'
}

{ #category : #specs }
ImageMeshGUI class >> defaultSpec [

	^ SpecBoxLayout newHorizontal
		add: (
		SpecGridLayout new
		add: #vmPathLabel at: 1@1;
		add: #vmPathInput at: 2@1;
		add: #imageDirectoryLabel at: 1@2;
		add: #imageDirectoryInput at: 2@2;
		add: #imageNameLabel at: 1@3;
		add: #imageNameInput at: 2@3;
		add: #imagesCountLabel at: 1@4;
		add: #imagesCountInput at: 2@4;
		add: #portLabel at: 1@5;
		add: #portInput at: 2@5;
		add: #startButton at: 1@6;
		add: #connectButton at: 2@6;		
		yourself);
		add: #imagesTable
]

{ #category : #'instance creation' }
ImageMeshGUI class >> open [

	<example>
	^ self new openWithSpec
]

{ #category : #initialization }
ImageMeshGUI >> initialExtent [
	^ (900@600) 
]

{ #category : #initialization }
ImageMeshGUI >> initializeWidgets [

	self additionalSubpresentersMap at: #vmPathLabel put: (self newLabel label: 'VM path:').
	self additionalSubpresentersMap at: #imageDirectoryLabel put: (self newLabel label: 'image directory:').
	self additionalSubpresentersMap at: #imageNameLabel put: (self newLabel label: 'image name:').
	self additionalSubpresentersMap at: #imagesCountLabel put: (self newLabel label: 'count:').
	self additionalSubpresentersMap at: #portLabel put: (self newLabel label: 'starting port:').
	
	vmPathInput := self newTextInput autoAccept: true.
	imageDirectoryInput := self newTextInput autoAccept: true.
	imageNameInput := self newTextInput autoAccept: true.
	imagesCountInput := self newNumberInput autoAccept: true.
	portInput := self newNumberInput autoAccept: true.

	startButton := self newButton label: 'Start'.
	connectButton := self newButton label: 'Connect'.

	imagesTable := self newTable.
	imagesTable
		addColumn: (StringTableColumn title: 'pid' evaluated: #pidString);
		addColumn: (StringTableColumn title: 'port' evaluated: #portString);
		addColumn: (StringTableColumn title: 'connected' evaluated: #isConnectedString);
		items: #().
]
