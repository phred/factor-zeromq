! Copyright (C) 2011 Fred Alger.
! See http://factorcode.org/license.txt for BSD license.
USING: alien alien.libraries alien.c-types
system combinators alien.syntax classes.struct literals math
zeromq.invariants ;

IN: zeromq.ffi

<<
"zeromq" {
    { [ os winnt? ]  [ "libzmq.dll" ] }
    { [ os macosx? ] [ "libzmq.dylib" ] }
    { [ os unix? ]   [ "libzmq.so" ] }
} cond cdecl add-library
>>
"zeromq" deploy-library



LIBRARY: zeromq

FUNCTION: void zmq_version ( int* major, int* minor, int* patch ) ;

#! /*  On Windows platform some of the standard POSIX errnos are not defined.    */
#! #ifndef ENOTSUP
#! #define ENOTSUP (ZMQ_HAUSNUMERO + 1)
#! #endif
#! #ifndef EPROTONOSUPPORT
#! #define EPROTONOSUPPORT (ZMQ_HAUSNUMERO + 2)
#! #endif
#! #ifndef ENOBUFS
#! #define ENOBUFS (ZMQ_HAUSNUMERO + 3)
#! #endif
#! #ifndef ENETDOWN
#! #define ENETDOWN (ZMQ_HAUSNUMERO + 4)
#! #endif
#! #ifndef EADDRINUSE
#! #define EADDRINUSE (ZMQ_HAUSNUMERO + 5)
#! #endif
#! #ifndef EADDRNOTAVAIL
#! #define EADDRNOTAVAIL (ZMQ_HAUSNUMERO + 6)
#! #endif
#! #ifndef ECONNREFUSED
#! #define ECONNREFUSED (ZMQ_HAUSNUMERO + 7)
#! #endif
#! #ifndef EINPROGRESS
#! #define EINPROGRESS (ZMQ_HAUSNUMERO + 8)
#! #endif

#! /*  Native 0MQ error codes.                                            */
ENUM: zmq_error_t
{ EMTHREAD $[ ZMQ_HAUSNUMERO 50 + ] }
{ EFSM $[ ZMQ_HAUSNUMERO 51 + ] }
{ ENOCOMPATPROTO $[ ZMQ_HAUSNUMERO 52 + ] }
{ ETERM $[ ZMQ_HAUSNUMERO 53 + ] } ;

FUNCTION: int zmq_errno ( ) ;
FUNCTION: char* zmq_strerror ( int errnum ) ;


CONSTANT: ZMQ_MAX_VSM_SIZE 30
CONSTANT: ZMQ_DELIMITER 31
CONSTANT: ZMQ_VSM 32
CONSTANT: ZMQ_MSG_MORE 1
CONSTANT: ZMQ_MSG_SHARED 128

STRUCT: zmq_msg_t
    { content void* }
    { flags uchar }
    { vsm_size uchar }
    { vsm_data uchar[ZMQ_MAX_VSM_SIZE] } ;   #! uchar-array[ZMQ_MAX_VSM_SIZE]


CALLBACK: void zmq_free_fn ( void* data, void* hint ) ;

FUNCTION: int zmq_msg_init ( zmq_msg_t *msg ) ;
FUNCTION: int zmq_msg_init_size ( zmq_msg_t *msg, size_t size ) ;
FUNCTION: int zmq_msg_init_data ( zmq_msg_t *msg, void *data, size_t size, zmq_free_fn *ffn, void *hint ) ;
FUNCTION: int zmq_msg_close ( zmq_msg_t *msg ) ;
FUNCTION: int zmq_msg_move ( zmq_msg_t *dest, zmq_msg_t *src ) ;
FUNCTION: int zmq_msg_copy ( zmq_msg_t *dest, zmq_msg_t *src ) ;
FUNCTION: void *zmq_msg_data ( zmq_msg_t *msg ) ;
FUNCTION: size_t zmq_msg_size ( zmq_msg_t *msg ) ;

FUNCTION: void *zmq_init ( int io_threads ) ;
FUNCTION: int zmq_term ( void *context ) ;

ENUM: zmq_socket_t { ZMQ_PAIR 0 } { ZMQ_PUB 1  } { ZMQ_SUB 2  } { ZMQ_REQ 3  }
    { ZMQ_REP 4  } { ZMQ_XREQ 5 } { ZMQ_XREP 6 } { ZMQ_PULL 7 } { ZMQ_PUSH 8 }
    { ZMQ_UPSTREAM 7 } { ZMQ_DOWNSTREAM 8 } ;

ENUM: zmq_sockopt_t { ZMQ_HWM 1 } { ZMQ_SWAP 3 } { ZMQ_AFFINITY 4 }
    { ZMQ_IDENTITY 5 } { ZMQ_SUBSCRIBE 6 } { ZMQ_UNSUBSCRIBE 7 } { ZMQ_RATE 8 }
    { ZMQ_RECOVERY_IVL 9 } { ZMQ_MCAST_LOOP 10 } { ZMQ_SNDBUF 11 }
    { ZMQ_RCVBUF 12 } { ZMQ_RCVMORE 13 } ;

#! /*  Send/recv options.                                                        */
CONSTANT: ZMQ_NOBLOCK 1
CONSTANT: ZMQ_SNDMORE 2

FUNCTION: void *zmq_socket ( void *context, zmq_socket_t type ) ;
FUNCTION: int zmq_close ( void *s ) ;
FUNCTION: int zmq_setsockopt ( void *s, zmq_sockopt_t option, void *optval, size_t optvallen ) ; 
FUNCTION: int zmq_getsockopt ( void *s, zmq_sockopt_t option, void *optval, size_t *optvallen ) ;
FUNCTION: int zmq_bind ( void *s, c-string addr ) ;
FUNCTION: int zmq_connect ( void *s, c-string addr ) ;
FUNCTION: int zmq_send ( void *s, zmq_msg_t *msg, int flags ) ;
FUNCTION: int zmq_recv ( void *s, zmq_msg_t *msg, int flags ) ;

CONSTANT: ZMQ_POLLIN 1
CONSTANT: ZMQ_POLLOUT 2
CONSTANT: ZMQ_POLLERR 4

STRUCT: zmq_pollitem_t 
    { socket void* }
    { fd int }
    { events short }
    { revents short } ;

FUNCTION: int zmq_poll ( zmq_pollitem_t *items, int nitems, long timeout ) ;

#! /******************************************************************************/
#! /*  Devices - Experimental.                                                   */
#! /******************************************************************************/

ENUM: zmq_device_t
{ ZMQ_STREAMER 1 }
{ ZMQ_FORWARDER 2 }
{ ZMQ_QUEUE 3 } ;

FUNCTION: int zmq_device ( zmq_device_t device, void* insocket, void* outsocket ) ;
