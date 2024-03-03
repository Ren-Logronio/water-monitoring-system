export default function Sensor({ sensor_id, name, unit }: { sensor_id: number, name: string, unit: string}) {
    return (
        <div>
            <p>{sensor_id}</p>
            <p>{name}</p>
            <p>{unit}</p>
        </div>
    );
}