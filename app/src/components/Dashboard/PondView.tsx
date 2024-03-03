export default function PondView({ device_id }: { device_id?: string})  {
    return (
        <div>
            <h1>Pond View</h1>
            <p>This is the pond view page: {device_id || "nada"}</p>
        </div>
    );
}