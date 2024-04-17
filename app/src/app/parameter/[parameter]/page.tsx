"use client";

import { useParams } from "next/navigation";

export default function ParameterPage() {
    // get parameter from the url
    const params = useParams();

    const test_data = [
        {
            reading: 30, recorded_at: "2021-10-01T00:00:00Z"
        },
        {
            reading: 35, recorded_at: "2021-10-02T00:00:00Z"
        },
        {
            reading: 40, recorded_at: "2021-10-03T00:00:00Z"
        },
        {
            reading: 45, recorded_at: "2021-10-04T00:00:00Z"
        },
        {
            reading: 50, recorded_at: "2021-10-05T00:00:00Z"
        },
    ]

    // idx, reading, date, time, actions
    // 0, 30, Feb 19, 12:00 PM, [insert record, edit record, remove record]

    return (
        <div>
            <h1>Parameter</h1>
            <p>{params.parameter}</p>
        </div>
    );
}