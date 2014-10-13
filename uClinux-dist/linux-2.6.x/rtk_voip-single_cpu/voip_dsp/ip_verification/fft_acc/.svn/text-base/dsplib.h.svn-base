
/*****************************************************************************

CONFIDENTIAL AND PROPRIETARY
Copyright (c) 2000 LEXRA, Inc.  All rights reserved.
This software was developed by Berkeley Design Technology, Inc. under
contract with LEXRA.  Send E-mail to <info@bdti.com> for further details.

******************************************************************************/

#ifndef DSPLIB_H
#define DSPLIB_H

#include <stddef.h>
#include <linux/types.h>

void
 vector_add( int16_t *, const int16_t *, const int16_t *, size_t, int scale );

int16_t
 vector_dot_product( const int16_t *, const int16_t *, size_t, int scale );

int16_t vector_max_abs( const int16_t *, size_t, size_t * );

void
 cross_correlation(
     int16_t *, const int16_t *, const int16_t *, size_t, size_t, size_t, int
 );

#define auto_correlation( output, input, num_samples, offset_start, num_offsets, scale ) cross_correlation( (output), (input), (input), (num_samples), (offset_start), (num_offsets), (scale) )


int16_t sinfix( int16_t );

#define cosfix( alpha ) sinfix( ( ( alpha ) + 0x4000)  );


void create_tone( int16_t *, size_t, int, int, int16_t );

void create_blackman_window( int16_t *, size_t );
void create_hanning_window( int16_t *, size_t );
void create_hamming_window( int16_t *, size_t );
void create_kaiser_window( int16_t *, size_t, uint16_t, int );
void create_chebyshev_window( int16_t *, int16_t *, size_t, uint16_t, int );
void apply_window( int16_t *, const int16_t *, const int16_t *, size_t );

void
 block_fir_filter(
     int16_t *,
     const int16_t *,
     size_t,
     const int16_t *,
     int16_t *,
     size_t,
     int
 );
void
 block_decimating_fir_filter(
     int16_t *,
     const int16_t *,
     size_t,
     const int16_t *,
     int16_t *,
     size_t,
     int,
     int
 );
void
 block_interpolating_fir_filter(
     int16_t *,
     const int16_t *,
     size_t,
     const int16_t *,
     int16_t *,
     size_t,
     int,
     int
 );

void
 block_complex_fir_filter(
     int16_t *,
     const int16_t *,
     size_t,
     const int16_t *,
     int16_t *,
     size_t,
     int
 );

int16_t
 lms_filter(
     int16_t *, int16_t, int16_t, int16_t *, int16_t *, size_t, int16_t );

void
 iir_biquad_filter(
     int16_t *, int16_t, const int16_t *, const int16_t *, int, int16_t * );

void create_fft_twiddles( int16_t *, int );
void complex_scale_fft( int16_t *, const int16_t *, const int16_t *, int );
void complex_unscale_fft( int16_t *, const int16_t *, const int16_t *, int );
void complex_scale_ifft( int16_t *, const int16_t *, const int16_t *, int );
void complex_unscale_ifft( int16_t *, const int16_t *, const int16_t *, int );

void fdct_8x8( int16_t *in, int16_t *out, int16_t *temp );
void idct_8x8( int16_t *in, int16_t *out, int16_t *temp );


#endif

