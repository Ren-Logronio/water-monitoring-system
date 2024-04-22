import mongoose, { Schema } from "mongoose";

export const ReadingSchema = new Schema({
    device_id: {
        type: String,
    },
    TMP: {
        type: Number,
    },
    TDS: {
        type: Number,
    },
    PH: {
        type: Number,
    },
    AMN: {
        type: Number,
    },
    timestamp: {
        type: Date,
        default: Date.now
    }
});

export const ReadingModel = mongoose.model("sensor-logs", ReadingSchema);
