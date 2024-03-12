import axios from "axios";
import { useEffect, useState } from "react"



export default function PondList({ farm_id }: { farm_id: number }) {
    const [ponds, setPonds] = useState<any[]>([])
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        axios.get(`/api/farm/pond?farm_id=${farm_id}`).then(response => {
            if (!response.data.results && response.data.results.length <= 0) {
                return;
            } 
            setPonds(response.data.results);
        }).catch(error => {
            console.error(error);
        }).finally(() => {
            setLoading(false);
        });
    }, [farm_id]);

    return (<div>
        {
            loading && <div>Loading...</div>
        }
        {
            !loading && <div>
                {ponds.map((pond, idx) => {
                    return <div key={idx}>{JSON.stringify(pond)}</div>
                })}
            </div>
        }
    </div>)
}