! Copyright (C) 2011 Fred Alger.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors alien.data alien.strings io.encodings.utf8 fry
kernel locals namespaces zeromq zeromq.ffi zeromq.errors continuations
byte-arrays sequences ;

IN: zeromq.messages

<PRIVATE
: zmq_msg_t>byte-array ( obj -- seq )
    [ zmq_msg_data ] [ zmq_msg_size ] bi memory>byte-array ;

PRIVATE>

: <zmq-message> ( seq -- msg )
    [ >byte-array ] [ length ] bi
    '[ _ _ f f zmq_msg_init_data ]
    { zmq_msg_t } swap
    with-out-parameters
    swap (check-zmq-error) ;

: <zmq-blank-message> ( -- msg )
    { zmq_msg_t } [ zmq_msg_init ] with-out-parameters swap (check-zmq-error) ;


: (close-zmq-message) ( msg -- )
    zmq_msg_close (check-zmq-error) ;

:: (with-message) ( quot msg -- msg' )
    msg quot curry
    [ msg (close-zmq-message) ] [ ] cleanup
    msg zmq_msg_t>byte-array ; inline

: with-new-message ( quot -- msg )
   <zmq-blank-message> (with-message) ; inline

: with-message ( msg quot -- msg' )
   swap (with-message) ; inline
