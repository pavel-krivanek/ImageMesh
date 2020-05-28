Class {
	#name : #ImageMeshGUI,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'vmPathInput',
		'imageDirectoryInput',
		'imageNameInput',
		'imagesCountInput',
		'portInput',
		'startButton',
		'connectButton',
		'killButton',
		'playgroundButton',
		'imagesTable',
		'workingModel',
		'connections',
		'notebook',
		'packagesList'
	],
	#category : #'ImageMesh-GUI'
}

{ #category : #specs }
ImageMeshGUI class >> defaultSpec [

	^ SpBoxLayout newHorizontal
		add: (
		SpBoxLayout newVertical add: (
		SpGridLayout new
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
		add: #playgroundButton at: 2@7;		
		yourself);
		add: #notebook);
		add: #imagesTable
]

{ #category : #'instance creation' }
ImageMeshGUI class >> open [

	<example>
	^ self new openWithSpec
]

{ #category : #initialization }
ImageMeshGUI >> connectImages [
	| combinations futures |
	self disconnectAll.
	self connections do: #connect.
	combinations := self eachToEachCombinationsFor: connections size.
	futures := connections
		withIndexCollect: [ :connection :index | 
			| f |
			connection peer logCr.
			f := [ connection peer
				evaluate: [ | peers myPeers myCombinations |
					Transcript show: index.
					peers := SmalltalkImage current
						at: #connections
						ifAbsentPut: [ Dictionary new ].
					myCombinations := combinations
						select: [ :e | e first = index ]
						thenCollect: #second.
					ImageMeshNode current index: index.
					myCombinations
						do: [ :remoteIndex | ImageMeshNode current connectTo: remoteIndex ] ] ]
				future.
			f
				onSuccessDo: [ :e | 
					connection isConnected: true.
					imagesTable adapter refreshList ] ]

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
	playgroundButton action: [ self openPlayground ].

]

{ #category : #initialization }
ImageMeshGUI >> initializeWidgets [

	| menu |
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
	killButton := self newButton label: 'Stop all'.
	playgroundButton := self newButton label: 'Playground'.

	imagesTable := self newTable.
	imagesTable
		addColumn: (SpStringTableColumn title: 'pid' evaluated: #pidString);
		addColumn: (SpStringTableColumn title: 'port' evaluated: #portString);
		addColumn: (SpStringTableColumn title: 'connected' evaluated: #isConnectedString);
		items: connections.
		
	menu := SpMenuPresenter new.
	menu addGroup: [ :group |
			group addItem: [ :item |
				item
					name: 'Connect';
					action: [ 
						imagesTable selection selectedItem connect.
						imagesTable adapter refreshList ]].
			group addItem: [ :item |
				item
					name: 'Disconnect';
					action: [ 
						imagesTable selection selectedItem disconnect.
						imagesTable adapter refreshList ]].
			group addItem: [ :item |
				item
					name: 'open Browser';
					action: [ 
						imagesTable selection selectedItem openBrowser ]].
			group addItem: [ :item |
				item
					name: 'open Playground';
					action: [ 
						imagesTable selection selectedItem openPlayground ]].
			group addItem: [ :item |
				item
					name: 'Inspect';
					action: [ imagesTable selection selectedItem inspect ]].
	].
	imagesTable contextMenu: menu. 	
	
	notebook := self newNotebook.
	notebook
		addPage: self packagesTab.
]

{ #category : #initialization }
ImageMeshGUI >> installOnNodes: package [

	| nodes data | 
	
	nodes := self connections select: #isConnected.
	nodes ifEmpty: [ ^ self ].
	data := nodes first mcPackageDataOf: package.
	nodes do: [ :node | 
		| future |
		future := [ node node mcInstallPackage: data ] future.
		future onSuccessDo: [ :value | self inform: package name asString ]
		 ].
	
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
ImageMeshGUI >> openPlayground [ 
	
	| playground bindings |

	playground := GTPlayground openContents: 'connections collect: [ :worker | worker peer evaluate: [ Mesh current remoteMeshes values collect: #index ] ].'.
	bindings := Dictionary newFrom: { #connections-> connections }.
	playground setBindings: bindings.
	

]

{ #category : #initialization }
ImageMeshGUI >> packagesTab [
	^ SpNotebookPage title: 'Packages' icon: (self iconNamed: #smallPackage) provider: [ 
		| menu |
		packagesList := self newList.
		packagesList enableSearch.
		self refreshPackagesList.
		packagesList display: [ :m | m name ].
		
		menu := SpMenuPresenter new.
		menu addGroup: [ :group |
			group addItem: [ :item |
				item
					name: 'Install on nodes';
					action: [ 
						self installOnNodes: packagesList selection selectedItem ]].
			group addItem: [ :item |
				item
					name: 'Browse';
					action: [ 
						packagesList selection selectedItem browse ]]].
		menu addGroup: [ :group |
			group addItem: [ :item |
				item
					name: 'Refresh';
					action: [ 
						self refreshPackagesList  ]].
	].
	packagesList contextMenu: menu.
		
		
		packagesList.
	]
]

{ #category : #initialization }
ImageMeshGUI >> refreshPackagesList [ 

	packagesList items: (RPackageOrganizer default packages sorted: [:a :b | a name <= b name ]).

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
