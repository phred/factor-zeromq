! Copyright (C) 2011 Fred Alger.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.c-types alien.data calendar io kernel math threads
zeromq zeromq.context zeromq.ffi zeromq.sockets strings ;

IN: zeromq.tests


: test-pub-server ( -- )
    [ ZMQ_PUB [
        "tcp://127.0.0.1:5566" bind
        10 [ "testing" send "."  print 1 seconds sleep ] times
        drop
      ] with-socket
    ] with-zmq-context ;

: test-sub-client ( -- )
      [ ZMQ_SUB [
          "tcp://127.0.0.1:5566"
          connect
          ZMQ_SUBSCRIBE "" setsockopt
          10 [ recv >string print ] times
        ] with-socket
      ] with-zmq-context drop ;
