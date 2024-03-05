import axios from "axios";
import { useEffect, useState } from "react";
import { NinetyRing } from "react-svg-spinners";
import Sensor from "./Sensor";
import { Badge } from "../ui/badge";

export default function PondView({ device_id }: { device_id?: string})  {
    const [sensors, setSensors] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        setSensors([]);
        setLoading(true);
        axios.get(`/api/sensor?device_id=${device_id}`).then(response => {
            if (!response.data.results || response.data.results.length <= 0) {
                setSensors([]);
                return;
            }
            setSensors(response.data.results.map((i:any) => ({...i, hidden: false, context: "", unshowable: false})));
        }).catch(error => {
            console.error(error);
        }).finally(() => {
            setLoading(false);
        });
    }, [device_id]);

    const removeSensorCallback = (trsensor: any) => {
        const newSensors = [ ...sensors.filter(sensor => sensor.sensor_id !== trsensor.sensor_id), {...trsensor, hidden: true, context: "No Readings", unshowable: true } ]
        setSensors(newSensors);
    }

    return (
        <div className="py-4">
            {
                loading ? <div className="flex justify-center items-center h-40 space-x-2">
                    <NinetyRing />
                    <p>Loading Sensors..</p>
                </div> 
                : sensors.filter(i => !i.hidden).length > 0 ? <>
                    <div className="flex flex-row space-x-2 mb-3">{
                        sensors
                            .filter(i => i.hidden)
                            .map(sensor => (
                                                <Badge key={sensor.sensor_id} className={`bg-sky-600 shadow-md ${sensor.unshowable ? "cursor-default hover:bg-sky-600" : "cursor-pointer hover:bg-sky-700"}`}>
                                                    {sensor.name} {sensor.context && `(${sensor.context})`}
                                                </Badge>
                                            )
                                )
                    }</div>
                    <div className="transition-all grid grid-cols-1 xl:grid-cols-2 gap-4">{
                        sensors
                            .filter(i => !i.hidden)
                            .map(sensor => <Sensor 
                                                key={sensor.sensor_id} 
                                                sensor={sensor} 
                                                hideCallback={(sensor: any) => {}} 
                                                emptyCallback={removeSensorCallback} />
                                )
                    }</div>
                </>
                : sensors.filter(i => i.hidden).length <= 0 && <p>No sensors found</p>
            }
        </div>
    );
}