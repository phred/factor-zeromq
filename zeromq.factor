! Copyright (C) 2011 Fred Alger.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.c-types alien.data kernel namespaces
fry locals io.encodings.utf8 alien.strings accessors 
continuations tools.continuations zeromq.ffi ;

IN: zeromq

SYMBOL: zmq-context
SYMBOL: zmq-msg

TUPLE: zmq-socket underlying ;

GENERIC# connect 1 ( obj addr -- obj )
GENERIC: close ( obj -- )
GENERIC# setsockopt 1 ( obj opt -- obj  )
GENERIC: recv ( obj -- msg )

: (zmq-context) ( -- obj )
    zmq-context get dup [ "no zmq context" throw ] unless ;

: new-zmq-msg ( -- msg )
    { zmq_msg_t } [ zmq_msg_init ] with-out-parameters nip ;

:: with-socket ( socket quot -- socket )
    socket underlying>> quot call socket ; inline


: <zmq-socket> ( type -- obj )
    (zmq-context) swap zmq_socket \ zmq-socket boa ;

M: zmq-socket connect ( socket addr -- socket* )
    '[ _ zmq_connect 0 = [ "connect error" throw ] unless ] with-socket ;

M: zmq-socket setsockopt ( socket opt -- socket )
    '[ _ "" utf8 string>alien 0 zmq_setsockopt
      0 = [ "setsockopt error" throw ] unless
     ] with-socket ;

: (zmq-recv-blocking) ( socket -- msg )
   [ underlying>>
   new-zmq-msg zmq-msg set
   zmq-msg get
   0 zmq_recv 0 = [ "recv error" throw ] unless
   zmq-msg get ] with-scope ; inline

M: zmq-socket recv ( socket -- msg )
    (zmq-recv-blocking) ;

M: zmq-socket close ( socket -- )
    [ zmq_close 0 = [ "close error" throw ] unless ] with-socket drop ;


: with-zmq-context ( quot -- )
    [
        1 zmq_init
        zmq-context set
        [ zmq-context get zmq_term drop ] [ ] cleanup
    ] with-scope ; inline


: zmq-version ( -- major minor patch )
    { int int int } [ zmq_version ] with-out-parameters ;
