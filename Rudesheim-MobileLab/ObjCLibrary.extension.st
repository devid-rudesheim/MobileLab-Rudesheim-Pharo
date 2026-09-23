Extension { #name : 'ObjCLibrary' }

{ #category : '*Rudesheim-MobileLab' }
ObjCLibrary >> sendDoubleMessage: aSelector to: aReceiver [
	"ObjCLibrary's own #sendMessage:to: always reads the return value as a bare pointer, which
	misreads a method whose real return type is a scalar double (like CLHeading>>-trueHeading) --
	on this platform's calling convention, a double return comes back through an SSE register, not
	the pointer-sized general-purpose register #sendMessage:to: reads. Declaring the return type as
	`double` here instead makes Pharo's FFI generate the correct call."
	^ self ffiCall: #(double objc_msgSend(void* aReceiver, void* aSelector)).
]
