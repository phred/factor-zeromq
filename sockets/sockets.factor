! Copyright (C) 2011 Fred Alger.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors alien.data alien.strings continuations fry
io.encodings.utf8 kernel locals namespaces
zeromq.errors zeromq.context zeromq.ffi zeromq.messages ;

IN: zeromq.sockets

TUPLE: zmq-socket underlying ;

GENERIC# connect 1 ( obj addr -- obj )
GENERIC# bind 1 ( obj addr -- obj )
GENERIC: close ( obj -- )
GENERIC# setsockopt 2 ( obj opt val -- obj )
GENERIC: recv ( obj -- obj msg )
GENERIC# send 1 ( obj msg -- obj )

:: with-socket ( socket quot -- socket )
    socket underlying>> quot curry call (check-zmq-error) socket ; inline

: <zmq-socket> ( type -- obj )
    (zmq-context) swap zmq_socket \ zmq-socket boa ;

M: zmq-socket connect ( socket addr -- socket* )
    '[ _ zmq_connect ] with-socket ;

M: zmq-socket bind ( socket addr -- socket* )
    '[ _ zmq_bind ] with-socket ;

M: zmq-socket setsockopt ( socket opt val -- socket )
    utf8 string>alien '[ _ _  0 zmq_setsockopt ] with-socket ;

: (zmq-recv-blocking) ( socket -- socket msg )
     [ '[ _ 0 zmq_recv ] with-socket ] with-new-message ; inline

M: zmq-socket recv ( socket -- socket msg )
    (zmq-recv-blocking) ;

: (zmq-send-blocking) ( socket msg -- socket )
     <zmq-message> [
         '[ _ 0 zmq_send ] with-socket
     ] with-message drop ; inline

M: zmq-socket send ( socket msg -- socket )
    (zmq-send-blocking) ;

M: zmq-socket close ( socket -- )
    [ zmq_close ] with-socket drop ;

