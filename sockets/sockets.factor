! Copyright (C) 2011 Fred Alger.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors alien.data alien.strings calendar
continuations destructors fry io.encodings.utf8 kernel locals
namespaces threads zeromq.context zeromq.errors zeromq.ffi
zeromq.messages tools.continuations ;

FROM: unix.ffi => EAGAIN ;

IN: zeromq.sockets

TUPLE: zmq-socket underlying ;

GENERIC# connect 1 ( obj addr -- obj )
GENERIC# bind 1 ( obj addr -- obj )
GENERIC: close ( obj -- )
GENERIC# setsockopt 2 ( obj opt val -- obj )
GENERIC: recv ( obj -- obj msg )
GENERIC# send 1 ( obj msg -- obj )

<PRIVATE
:: (call-with-socket) ( socket quot -- socket )
    socket underlying>> quot curry call socket ; inline

: again? ( -- ? )
    zmq_errno EAGAIN = ;

:: (should-retry?) ( retval -- ?* )
    retval -1 = again? and dup [ retval (check-zmq-error) ] unless ;

: (retry-loop) ( quot -- quot' )
    [ (should-retry?) yield ] compose
    [ curry loop ] curry ; inline

: call-with-socket-nonblocking ( socket quot -- socket )
    (retry-loop) (call-with-socket) ; inline

: call-with-socket ( socket quot -- socket )
    [ (check-zmq-error) ] compose (call-with-socket) ; inline


PRIVATE>

: <zmq-socket> ( type -- obj )
    (zmq-context) swap zmq_socket \ zmq-socket boa ;

M: zmq-socket connect ( socket addr -- socket* )
    '[ _ zmq_connect ] call-with-socket ;

M: zmq-socket bind ( socket addr -- socket* )
    '[ _ zmq_bind ] call-with-socket ;

M: zmq-socket setsockopt ( socket opt val -- socket )
    utf8 string>alien '[ _ _  0 zmq_setsockopt ] call-with-socket ;

: (zmq-recv-nonblocking) ( socket -- socket msg )
     [ '[ _ ZMQ_NOBLOCK zmq_recv ] call-with-socket-nonblocking ] with-new-message ; inline

M: zmq-socket recv ( socket -- socket msg )
    (zmq-recv-nonblocking) ;

: (zmq-send-nonblocking) ( socket msg -- socket )
     <zmq-message> [
         '[ _ ZMQ_NOBLOCK zmq_send ] call-with-socket-nonblocking
     ] with-message drop ; inline

M: zmq-socket send ( socket msg -- socket )
    (zmq-send-nonblocking) ;

M: zmq-socket close ( socket -- )
    [ zmq_close ] call-with-socket drop ;


: with-socket ( socket-type quot -- )
    [ <zmq-socket> ] dip with-disposal ; inline

M: zmq-socket dispose ( obj -- )
    close ;
