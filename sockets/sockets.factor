! Copyright (C) 2011 Fred Alger.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors alien.data alien.strings continuations fry
io.encodings.utf8 kernel locals namespaces
zeromq.errors zeromq.context zeromq.ffi zeromq.messages ;

IN: zeromq.sockets

TUPLE: zmq-socket underlying ;

GENERIC# connect 1 ( obj addr -- obj )
GENERIC: close ( obj -- )
GENERIC# setsockopt 1 ( obj opt -- obj  )
GENERIC: recv ( obj -- obj )

:: with-socket ( socket quot -- socket )
    socket underlying>> quot curry call (check-zmq-error) socket ; inline

: <zmq-socket> ( type -- obj )
    (zmq-context) swap zmq_socket \ zmq-socket boa ;

M: zmq-socket connect ( socket addr -- socket* )
    '[ _ zmq_connect ] with-socket ;

M: zmq-socket setsockopt ( socket opt -- socket )
    '[ _ "" utf8 string>alien 0 zmq_setsockopt ] with-socket ;

: (zmq-recv-blocking) ( socket -- msg )
     [ '[ _ 0 zmq_recv ] with-socket drop ] with-message ; inline

M: zmq-socket recv ( socket -- msg )
    (zmq-recv-blocking) ;

M: zmq-socket close ( socket -- )
    [ zmq_close ] with-socket drop ;

