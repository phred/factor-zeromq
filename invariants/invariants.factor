
IN: zeromq.invariants

#! /******************************************************************************/
#! /*  0MQ errors.                                                               */
#! /******************************************************************************/
#! 
#! /*  A number random anough not to collide with different errno ranges on      */
#! /*  different OSes. The assumption is that error_t is at least 32-bit type.   */
CONSTANT: ZMQ_HAUSNUMERO 156384712
