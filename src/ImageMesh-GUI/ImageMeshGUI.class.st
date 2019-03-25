Class {
	#name : #ImageMeshGUI,
	#superclass : #ComposablePresenterWithModel,
	#instVars : [
		'vmPathInput',
		'imageDirectoryInput',
		'imageNameInput',
		'imagesCountInput',
		'portInput',
		'startButton',
		'connectButton',
		'killButton',
		'imagesTable',
		'workingModel',
		'connections'
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
		add: #killButton at: 1@7;		
		yourself);
		add: #imagesTable
]

{ #category : #'instance creation' }
ImageMeshGUI class >> open [

	<example>
	^ self new openWithSpec
]

{ #category : #initialization }
ImageMeshGUI >> connectImages [

	| combinations  futures |
	self disconnectAll.	
	
	self connections do: #connect.
	
	combinations := self eachToEachCombinationsFor: connections size.
	futures := connections withIndexCollect: [ :connection :index | 
		| f  | 
		connection peer  logCr.
		f := [ connection peer evaluate: [
			| peers myPeers myCombinations |
			Transcript show: index.
			peers := 	SmalltalkImage current at: #connections ifAbsentPut: [ Dictionary new ].
			myCombinations := combinations select: [ :e | e first = index ] thenCollect: #second.
			Mesh current index: index.
			myCombinations do: [ :remoteIndex | 
				Mesh current connectTo: remoteIndex.
				 ] ].				
		] future.
		f onSuccessDo: [ :e | Transcript show: 'worker '; show: index; show: ' finished: '; show: e; cr. ] ].

"workers collect: [ :worker | worker evaluate: [ Mesh current remoteMeshes values collect: #index ] ] .
"
]

{ #category : #initialization }
ImageMeshGUI >> connections [ 

	^ connections
]

{ #category : #initialization }
ImageMeshGUI >> disconnectAll [

	connections do: #disconnect.
	[TlpRemoteIDE disconnectAll] on: Warning do: [ :e | e resume ].
	TKTCommonQueueWorkerPool allInstancesDo: #reset.

	
]

{ #category : #initialization }
ImageMeshGUI >> eachToEachCombinationsFor: nodesCount [

	| combinations out |

	combinations := Set new.
	1 to: nodesCount do: [ :a |
		out := true.
		a+1 to: nodesCount do: [ :b |
			combinations add: (
				out ifTrue: [ { a. b } ] ifFalse: [ { b. a } ]).
			out := out not. ] ].

	^ combinations collect: [:e | e asArray] as: Array.
]

{ #category : #initialization }
ImageMeshGUI >> fillFormWithWorkingModel [

	| aModel |
	aModel := workingModel.

	imagesCountInput number: aModel imagesCount.
	vmPathInput text:	aModel vmPath.
	imageDirectoryInput text: aModel workingDirectory.
	imageNameInput	text: aModel imageName.
	vmPathInput	text: aModel vmPath.
	portInput number:	aModel port.
		
	imagesTable items: connections.
]

{ #category : #initialization }
ImageMeshGUI >> fillModelWithFormContent [

	workingModel
		imagesCount: imagesCountInput number;
		vmPath: vmPathInput text;
		workingDirectory: imageDirectoryInput text;
		imageName: imageNameInput text;
		vmPath: vmPathInput text;
		vmPath: vmPathInput text;
		port: portInput number.
		

]

{ #category : #initialization }
ImageMeshGUI >> initialExtent [
	^ 900@600 
]

{ #category : #initialization }
ImageMeshGUI >> initialize [

	connections := OrderedCollection new.
	self model: ImageMeshControlModel new.

	super initialize.
]

{ #category : #initialization }
ImageMeshGUI >> initializePresenter [

	startButton action: [ self startImages ].
	connectButton action: [ self connectImages ].
	killButton action: [ self killImages ].

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
	killButton := self newButton label: 'Kill all'.

	imagesTable := self newTable.
	imagesTable
		addColumn: (StringTableColumn title: 'pid' evaluated: #pidString);
		addColumn: (StringTableColumn title: 'port' evaluated: #portString);
		addColumn: (StringTableColumn title: 'connected' evaluated: #isConnectedString);
		items: connections.
]

{ #category : #initialization }
ImageMeshGUI >> killImages [

	connections do: [ :each | each process terminate ].
	connections := OrderedCollection new.
	
	imagesTable items: connections.

]

{ #category : #initialization }
ImageMeshGUI >> modelChanged [

	workingModel := self model copy.

	self fillFormWithWorkingModel.

	
]

{ #category : #initialization }
ImageMeshGUI >> startImages [

	self fillModelWithFormContent.
	
	self model: workingModel.
	self announcingObject valueChanged.
	
	self startImagesWith: self model.
	
	imagesTable items: connections.

]

{ #category : #initialization }
ImageMeshGUI >> startImagesWith: aConnectionModel [

	connections := (1 to: aConnectionModel imagesCount) collect: [ :workerId | 
		| port process formattedArguments|
		port := workerId + (aConnectionModel port - 1).
		
		formattedArguments := aConnectionModel arguments collect: [ :each | each format: { port } ].

		process := OSSUnixSubprocess new
			command: aConnectionModel vmPath;
			workingDirectory: aConnectionModel workingDirectory;
			arguments: { '-nodisplay'. aConnectionModel imageName }, formattedArguments;
			redirectStdout;
			run.
			
		ImageMeshConnectionModel new 
			isConnected: false;
			port: port;
			process: process;
			pid: process pid.
	].


]
