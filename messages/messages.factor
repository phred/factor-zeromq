! Copyright (C) 2011 Fred Alger.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors alien.data alien.strings io.encodings.utf8
kernel locals namespaces zeromq zeromq.ffi zeromq.errors continuations ;

IN: zeromq.messages

<PRIVATE

: <zmq-message> ( -- msg )
    { zmq_msg_t } [ zmq_msg_init ] with-out-parameters swap (check-zmq-error) ;

: zmq_msg_t>byte-array ( obj -- seq )
    [ zmq_msg_data ] [ zmq_msg_size ] bi memory>byte-array ;

PRIVATE>


: (close-zmq-message) ( msg -- )
    zmq_msg_close (check-zmq-error) ;


:: (with-message) ( quot message -- msg )
    message quot curry
    [ message (close-zmq-message) ] [ ] cleanup
    message zmq_msg_t>byte-array ; inline

: with-message ( quot -- msg )
   <zmq-message> (with-message) ; inline
