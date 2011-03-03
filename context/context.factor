! Copyright (C) 2011 Fred Alger.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.c-types alien.data kernel namespaces
fry locals io.encodings.utf8 alien.strings accessors 
continuations zeromq.ffi ;

IN: zeromq.context

SYMBOL: zmq-context


: (zmq-context) ( -- obj )
    zmq-context get dup [ "no zmq context" throw ] unless ;

: with-zmq-context ( quot -- )
    [
        1 zmq_init
        zmq-context set
        [ zmq-context get zmq_term drop ] [ ] cleanup
    ] with-scope ; inline

