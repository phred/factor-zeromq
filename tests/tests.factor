! Copyright (C) 2011 Fred Alger.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.c-types alien.data zeromq zeromq.alien ;
IN: zeromq.tests

IN: zeromq.tests


: sub_socket_test ( -- )
    [
        zmq-socket
    ] with-zmq-context ;


#! : test-with-zmq ( -- )
#!     [ 
#!         
#!     ] with-zmq-context ;
