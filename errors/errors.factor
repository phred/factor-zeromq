! Copyright (C) 2011 Fred Alger.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.c-types alien.data kernel namespaces
fry locals io.encodings.utf8 alien.strings accessors 
continuations zeromq.ffi ;

IN: zeromq.errors

: (zmq-err-message) ( -- str )
    zmq_errno zmq_strerror utf8 alien>string ;

: (check-zmq-error) ( retval -- )
    0 = [ (zmq-err-message) throw ] unless ;

