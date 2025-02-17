#ifndef PROTOCOL_H
#define PROTOCOL_H

#include <cmp/cmp.h>
#include <can_driver.h>
#include <datagram-messages/service_call.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef uint64_t timestamp_t;

// service calls
bool tx_cb(cmp_ctx_t *in, cmp_ctx_t *out, void *arg);
bool bit_rate_cb(cmp_ctx_t *in, cmp_ctx_t *out, void *arg);
bool filter_cb(cmp_ctx_t *in, cmp_ctx_t *out, void *arg);
bool bus_voltage_cb(cmp_ctx_t *in, cmp_ctx_t *out, void *arg);
bool bus_power_cb(cmp_ctx_t *in, cmp_ctx_t *out, void *arg);
bool silent_cb(cmp_ctx_t *in, cmp_ctx_t *out, void *arg);
bool loop_back_cb(cmp_ctx_t *in, cmp_ctx_t *out, void *arg);
bool hw_version_cb(cmp_ctx_t *in, cmp_ctx_t *out, void *arg);
bool sw_version_cb(cmp_ctx_t *in, cmp_ctx_t *out, void *arg);
bool name_cb(cmp_ctx_t *in, cmp_ctx_t *out, void *arg);

extern struct service_entry_s service_calls[];

// messages
void can_drop_msg_encode(cmp_ctx_t *cmp);
void can_error_msg_encode(cmp_ctx_t *cmp, timestamp_t timestamp);
void can_rx_msg_encode(cmp_ctx_t *cmp, struct can_frame_s *frame, timestamp_t timestamp);

#ifdef __cplusplus
}
#endif

#endif /* PROTOCOL_H */
