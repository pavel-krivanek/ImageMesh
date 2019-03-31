Extension { #name : #TKTProfile }

{ #category : #'*ImageMesh-Node' }
TKTProfile >> activateProfile [
"	self debugging
		ifTrue: [ self options
				do: [ :option | self assert: (self at: option) isDebuggingCompatible description: ('The option{1} is not debugging compatible! ' format: {option}) ].
			TKTDebugger enable ]
		ifFalse: [ TKTDebugger disable ]."
	self runner start
]
