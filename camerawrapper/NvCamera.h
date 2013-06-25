#include <hardware/hardware.h>
#include <hardware/camera.h>

typedef struct nv_camera_device_ops {
    /** Set the ANativeWindow to which preview frames are sent */
    int (*set_preview_window)(struct nv_camera_device *,
            struct preview_stream_ops *window);

    /** Set the notification and data callbacks */
    void (*set_callbacks)(struct nv_camera_device *,
            camera_notify_callback notify_cb,
            camera_data_callback data_cb,
            camera_data_timestamp_callback data_cb_timestamp,
            camera_request_memory get_memory,
            void *user);

    /**
     * The following three functions all take a msg_type, which is a bitmask of
     * the messages defined in include/ui/Camera.h
     */

    /**
     * Enable a message, or set of messages.
     */
    void (*enable_msg_type)(struct nv_camera_device *, int32_t msg_type);

    /**
     * Disable a message, or a set of messages.
     *
     * Once received a call to disableMsgType(CAMERA_MSG_VIDEO_FRAME), camera
     * HAL should not rely on its client to call releaseRecordingFrame() to
     * release video recording frames sent out by the cameral HAL before and
     * after the disableMsgType(CAMERA_MSG_VIDEO_FRAME) call. Camera HAL
     * clients must not modify/access any video recording frame after calling
     * disableMsgType(CAMERA_MSG_VIDEO_FRAME).
     */
    void (*disable_msg_type)(struct nv_camera_device *, int32_t msg_type);

    /**
     * Query whether a message, or a set of messages, is enabled.  Note that
     * this is operates as an AND, if any of the messages queried are off, this
     * will return false.
     */
    int (*msg_type_enabled)(struct nv_camera_device *, int32_t msg_type);

    /**
     * Start preview mode.
     */
    int (*start_preview)(struct nv_camera_device *);

    /**
     * Stop a previously started preview.
     */
    void (*stop_preview)(struct nv_camera_device *);

    /**
     * Returns true if preview is enabled.
     */
    int (*preview_enabled)(struct nv_camera_device *);

    /**
     * Request the camera HAL to store meta data or real YUV data in the video
     * buffers sent out via CAMERA_MSG_VIDEO_FRAME for a recording session. If
     * it is not called, the default camera HAL behavior is to store real YUV
     * data in the video buffers.
     *
     * This method should be called before startRecording() in order to be
     * effective.
     *
     * If meta data is stored in the video buffers, it is up to the receiver of
     * the video buffers to interpret the contents and to find the actual frame
     * data with the help of the meta data in the buffer. How this is done is
     * outside of the scope of this method.
     *
     * Some camera HALs may not support storing meta data in the video buffers,
     * but all camera HALs should support storing real YUV data in the video
     * buffers. If the camera HAL does not support storing the meta data in the
     * video buffers when it is requested to do do, INVALID_OPERATION must be
     * returned. It is very useful for the camera HAL to pass meta data rather
     * than the actual frame data directly to the video encoder, since the
     * amount of the uncompressed frame data can be very large if video size is
     * large.
     *
     * @param enable if true to instruct the camera HAL to store
     *        meta data in the video buffers; false to instruct
     *        the camera HAL to store real YUV data in the video
     *        buffers.
     *
     * @return OK on success.
     */
    int (*store_meta_data_in_buffers)(struct nv_camera_device *, int enable);

    /**
     * Start record mode. When a record image is available, a
     * CAMERA_MSG_VIDEO_FRAME message is sent with the corresponding
     * frame. Every record frame must be released by a camera HAL client via
     * releaseRecordingFrame() before the client calls
     * disableMsgType(CAMERA_MSG_VIDEO_FRAME). After the client calls
     * disableMsgType(CAMERA_MSG_VIDEO_FRAME), it is the camera HAL's
     * responsibility to manage the life-cycle of the video recording frames,
     * and the client must not modify/access any video recording frames.
     */
    int (*start_recording)(struct nv_camera_device *);

    /**
     * Stop a previously started recording.
     */
    void (*stop_recording)(struct nv_camera_device *);

    /**
     * Returns true if recording is enabled.
     */
    int (*recording_enabled)(struct nv_camera_device *);

    /**
     * Release a record frame previously returned by CAMERA_MSG_VIDEO_FRAME.
     *
     * It is camera HAL client's responsibility to release video recording
     * frames sent out by the camera HAL before the camera HAL receives a call
     * to disableMsgType(CAMERA_MSG_VIDEO_FRAME). After it receives the call to
     * disableMsgType(CAMERA_MSG_VIDEO_FRAME), it is the camera HAL's
     * responsibility to manage the life-cycle of the video recording frames.
     */
    void (*release_recording_frame)(struct nv_camera_device *,
                    const void *opaque);

    /**
     * Start auto focus, the notification callback routine is called with
     * CAMERA_MSG_FOCUS once when focusing is complete. autoFocus() will be
     * called again if another auto focus is needed.
     */
    int (*auto_focus)(struct nv_camera_device *);

    /**
     * Cancels auto-focus function. If the auto-focus is still in progress,
     * this function will cancel it. Whether the auto-focus is in progress or
     * not, this function will return the focus position to the default.  If
     * the camera does not support auto-focus, this is a no-op.
     */
    int (*cancel_auto_focus)(struct nv_camera_device *);

    /**
     * Take a picture.
     */
    int (*take_picture)(struct nv_camera_device *);

    /**
     * Cancel a picture that was started with takePicture. Calling this method
     * when no picture is being taken is a no-op.
     */
    int (*cancel_picture)(struct nv_camera_device *);

    /**
     * Set the camera parameters. This returns BAD_VALUE if any parameter is
     * invalid or not supported.
     */
    int (*set_parameters)(struct nv_camera_device *, const char *parms);

    /** Retrieve the camera parameters.  The buffer returned by the camera HAL
        must be returned back to it with put_parameters, if put_parameters
        is not NULL.
     */
    char *(*get_parameters)(struct nv_camera_device *);

    /** The camera HAL uses its own memory to pass us the parameters when we
        call get_parameters.  Use this function to return the memory back to
        the camera HAL, if put_parameters is not NULL.  If put_parameters
        is NULL, then you have to use free() to release the memory.
    */
    void (*put_parameters)(struct nv_camera_device *, char *);

    /**
     * Send command to camera driver.
     */
    int (*send_command)(struct nv_camera_device *,
                int32_t cmd, int32_t arg1, int32_t arg2);

    /**
     * Release the hardware resources owned by this object.  Note that this is
     * *not* done in the destructor.
     */
    void (*release)(struct nv_camera_device *);

    /**
     * Dump state of the camera hardware
     */
    int (*dump)(struct nv_camera_device *, int fd);
    

    int (*set_custom_parameters)(struct nv_camera_device *, const char *parms);
    char *(*get_custom_parameters)(struct nv_camera_device *);
} nv_camera_device_ops_t;

typedef struct nv_camera_device {
    /**
     * nv_camera_device.common.version must be in the range
     * HARDWARE_DEVICE_API_VERSION(0,0)-(1,FF). NV_CAMERA_DEVICE_API_VERSION_1_0 is
     * recommended.
     */
    hw_device_t common;
    nv_camera_device_ops_t *ops;
    void *priv;
} nv_camera_device_t;
