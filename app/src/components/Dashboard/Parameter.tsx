/* eslint-disable jsx-a11y/alt-text */
/* eslint-disable @next/next/no-img-element */

import axios from "axios";
import { createRef, useCallback, useEffect, useLayoutEffect, useState } from "react";
import { NinetyRing } from "react-svg-spinners";
import { Button } from "../ui/button";
import moment from "moment";
import ParameterGraph from "./Parameter/Parameter.graph";


// const useDimensions = (containingDiv: any) => { 
//     const [ chartDimensions, setChartDimensions ] = useState<any>({ width: 0, height: 0 });
//     useEffect(() => {
//         const updateDimensions = (containingDiv: any) => { 
//             if (containingDiv.current) {
//                 console.log("resized")
//                 const { width, height } = containingDiv.current.getBoundingClientRect();
//                 setChartDimensions({ width, height });
//             }
//         }
//         updateDimensions(containingDiv);
//         const event = window.addEventListener('resize', updateDimensions);
//         console.log("event", event);
//         return () => window.removeEventListener('resize', updateDimensions);
//     }, []);

//     return chartDimensions;
// }

export default function Parameter({ parameter, hideCallback }: { parameter: any, hideCallback: (parameter: any) => void }) {
    const [readings, setReadings] = useState<any[]>([]);
    const [hover, setHover] = useState<boolean>(false);
    const [loading, setLoading] = useState(true);
    const containingDiv = createRef<HTMLDivElement>();
    // const chartDimensions = useDimensions(containingDiv);

    useEffect(() => {
        axios.get(`/api/reading?parameter_id=${parameter.parameter_id}`).then((response) => {
            if (response.data.results && response.data.results.length > 0) {
                setReadings(response.data.results.sort((a: any, b: any) => moment(a.recorded_at).diff(b.recorded_at)));

            }
        }).catch((error) => {
            console.error(error);
        }).finally(() => {
            setLoading(false);
        });
    }, [parameter]);


    // update the hover state when mouse enters and leaves the div
    const handleMouseEnter = () => {
        setHover(true);
    }
    const handleMouseLeave = () => {
        setHover(false);
    }

    return (
        <div ref={containingDiv} onMouseEnter={handleMouseEnter} onMouseLeave={handleMouseLeave}
            className={`${readings.length <= 0 ? "hidden" : "select-none relative rounded-[var(--radius)] overflow-hidden flex min-h-[352px] bg-white shadow-md hover:shadow-lg flex-col justify-center items-center"} `}>

            {/* Loading spinner */}
            {loading && <NinetyRing />}

            {/* Parameter details */}
            {!loading && readings.length > 0 &&
                <>
                    <div className={`absolute z-40 size-full flex flex-col justify-end transition-all ${hover ? 'opacity-0 pointer-events-none' : 'opacity-100'}`}>
                        <div className="text-blue-900 mx-7 mb-4">
                            <h1 className="text-[20px] leading-[28px] font-medium">{parameter.name}</h1>
                            <div className="flex flex-row items-center space-x-2">
                                <p className="text-[40px] leading-[32px] m-0 font-semibold">{readings[readings.length - 1].value}</p>
                                <p className="text-[32px] leading-[26px] m-0 font-semibold">{parameter.unit}</p>
                            </div>
                            <p className="text-[14px] font-normal m-0">Last recorded reading</p>
                        </div>
                    </div>
                    <img src="./gradient-blue.png" className={`absolute bottom-0 left-0 z-30 ${hover ? 'opacity-0 pointer-events-none' : 'opacity-100'}`} />

                    {/* Graph action buttons */}
                    <div className={`absolute z-40 top-0 left-0 min-w-full min-h-[20px] flex flex-row justify-end pt-2 pr-2`}>
                        <Button variant="ghost" className="p-2">
                            <img src="./edit-logo.png" className="size-5" />
                        </Button>
                        <Button variant="ghost" className="p-2">
                            <img src="./print-logo.png" className="size-5" />
                        </Button>
                        <Button variant="ghost" className="p-2">
                            <img src="./gear-logo.png" className="size-5" />
                        </Button>
                    </div>

                    {/* Parameter graphs */}
                    <ParameterGraph readings={readings} parameter={parameter} hover={hover} />
                </>
            }

            {/* No readings found */}
            {!loading && readings.length <= 0 &&
                <>
                    <p>No {parameter.name} readings found</p>
                </>
            }

        </div>
    );
}