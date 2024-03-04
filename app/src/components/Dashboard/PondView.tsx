import axios from "axios";
import { useEffect, useState } from "react";
import { NinetyRing } from "react-svg-spinners";
import Sensor from "./Sensor";

export default function PondView({ device_id }: { device_id?: string})  {
    const [sensors, setSensors] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        setLoading(true);
        axios.get(`/api/sensor?device_id=${device_id}`).then(response => {
            if (!response.data.results || response.data.results.length <= 0) {
                setSensors([]);
                return;
            }
            setSensors(response.data.results);
        }).catch(error => {
            console.error(error);
        }).finally(() => {
            setLoading(false);
        });
    }, [device_id]);

    return (
        <div className="py-4">
            {
                loading ? <div className="flex justify-center items-center h-40 space-x-2">
                    <NinetyRing />
                    <p>Loading Sensors..</p>
                </div> 
                : sensors.length > 0 ? <div className="transition-all grid grid-cols-1 lg:grid-cols-2">{
                    sensors.map(sensor => <Sensor key={sensor.sensor_id} sensor_id={sensor.sensor_id} name={sensor.name} unit={sensor.unit} />)
                }</div>
                : <p>No sensors found</p>
            }
        </div>
    );
}