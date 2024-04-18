import mongoose, { Schema } from "mongoose";

export const ReadingSchema = new Schema({
    deviceId: {
        type: String,
    },
    temperature: {
        type: Number,
    },
    tds: {
        type: Number,
    },
    ph: {
        type: Number,
    },
    ammonia: {
        type: Number,
    },
    timestamp: {
        type: Date,
        default: Date.now
    }
});

export const readingModel = mongoose.model("sensor-logs", ReadingSchema);