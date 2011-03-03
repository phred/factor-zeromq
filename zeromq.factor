! Copyright (C) 2011 Fred Alger.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.c-types alien.data kernel namespaces
fry locals io.encodings.utf8 alien.strings accessors 
zeromq.ffi ;

IN: zeromq

: zmq-version ( -- major minor patch )
    { int int int } [ zmq_version ] with-out-parameters ;
