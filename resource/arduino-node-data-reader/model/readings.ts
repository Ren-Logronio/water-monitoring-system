import mongoose, { Schema } from "mongoose";
import { connection } from "../lib/mongodb"

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

export const ReadingModel = mongoose.model("sensor-logs", ReadingSchema);
