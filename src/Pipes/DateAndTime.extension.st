Extension { #name : #DateAndTime }

{ #category : #'*Pipes' }
DateAndTime >> asMilliSeconds [
	"Answer the number of milliseconds since midnight"

	^ self asSeconds * 1000 + ((nanos / 1000000.0) truncated)

]
