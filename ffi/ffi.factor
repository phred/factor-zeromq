! Copyright (C) 2011 Fred Alger.
! See http://factorcode.org/license.txt for BSD license.
USING: alien alien.libraries alien.c-types
system combinators alien.syntax classes.struct literals math
zeromq.constants ;

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

#! /*  Native 0MQ error codes.                                                   */
CONSTANT: EMTHREAD $[ ZMQ_HAUSNUMERO 50 + ]
CONSTANT: EFSM $[ ZMQ_HAUSNUMERO 51 + ]
CONSTANT: ENOCOMPATPROTO $[ ZMQ_HAUSNUMERO 52 + ]
CONSTANT: ETERM $[ ZMQ_HAUSNUMERO 53 + ]

#! /*  This function retrieves the errno as it is known to 0MQ library. The goal */
#! /*  of this function is to make the code 100% portable, including where 0MQ   */
#! /*  compiled with certain CRT library (on Windows) is linked to an            */
#! /*  application that uses different CRT library.                              */
FUNCTION: int zmq_errno ( ) ;

#! /*  Resolves system errors and 0MQ errors to human-readable string.           */
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

#! /*  Socket types.                                                             */ 
CONSTANT: ZMQ_PAIR 0
CONSTANT: ZMQ_PUB 1
CONSTANT: ZMQ_SUB 2
CONSTANT: ZMQ_REQ 3
CONSTANT: ZMQ_REP 4
CONSTANT: ZMQ_XREQ 5
CONSTANT: ZMQ_XREP 6
CONSTANT: ZMQ_PULL 7
CONSTANT: ZMQ_PUSH 8
ALIAS: ZMQ_UPSTREAM ZMQ_PULL    #!   /*  Old alias, remove in 3.x               */
ALIAS: ZMQ_DOWNSTREAM ZMQ_PUSH  #!   /*  Old alias, remove in 3.x               */

#! /*  Socket options.                                                           */
CONSTANT: ZMQ_HWM 1
CONSTANT: ZMQ_SWAP 3
CONSTANT: ZMQ_AFFINITY 4
CONSTANT: ZMQ_IDENTITY 5
CONSTANT: ZMQ_SUBSCRIBE 6
CONSTANT: ZMQ_UNSUBSCRIBE 7
CONSTANT: ZMQ_RATE 8
CONSTANT: ZMQ_RECOVERY_IVL 9
CONSTANT: ZMQ_MCAST_LOOP 10
CONSTANT: ZMQ_SNDBUF 11
CONSTANT: ZMQ_RCVBUF 12
CONSTANT: ZMQ_RCVMORE 13

#! /*  Send/recv options.                                                        */
CONSTANT: ZMQ_NOBLOCK 1
CONSTANT: ZMQ_SNDMORE 2

FUNCTION: void *zmq_socket ( void *context, int type ) ;
FUNCTION: int zmq_close ( void *s ) ;
#! FUNCTION: int zmq_setsockopt ( void *s, int option, const void *optval, size_t optvallen ) ; 
FUNCTION: int zmq_setsockopt ( void *s, int option, void *optval, size_t optvallen ) ; 
FUNCTION: int zmq_getsockopt ( void *s, int option, void *optval, size_t *optvallen ) ;
#! FUNCTION: int zmq_bind ( void *s, const char *addr ) ;
FUNCTION: int zmq_bind ( void *s, c-string addr ) ;
#! FUNCTION: int zmq_connect ( void *s, const char *addr ) ;
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

CONSTANT: ZMQ_STREAMER 1
CONSTANT: ZMQ_FORWARDER 2
CONSTANT: ZMQ_QUEUE 3

FUNCTION: int zmq_device ( int device, void* insocket, void* outsocket ) ;
