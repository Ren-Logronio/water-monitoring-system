"use client";

import { useParams } from "next/navigation";

export default function () {
    // get parameter from the url
    const params = useParams();

    return (
        <div>
            <h1>Parameter</h1>
            <p>{params.parameter}</p>
        </div>
    );
}