import axios from "axios";
import { useEffect, useState } from "react";
import { NinetyRing } from "react-svg-spinners";
import Parameter from "./Parameter";
import { Badge } from "../ui/badge";

export default function PondView({ pond_id }: { pond_id?: string }) {
    const [parameters, setParameters] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        setParameters([]);
        setLoading(true);
        axios.get(`/api/parameter?pond_id=${pond_id}`).then(response => {
            if (!response.data.results || response.data.results.length <= 0) {
                setParameters([]);
                return;
            }
            setParameters(response.data.results.map((i: any) => ({ ...i, hidden: false, context: "", unshowable: false })));
        }).catch(error => {
            console.error(error);
        }).finally(() => {
            setLoading(false);
        });
    }, [pond_id]);

    const removeSensorCallback = (trparam: any) => {
        const newSensors = [...parameters.filter(parameter => parameter.parameter_id !== trparam.parameter_id), { ...trparam, hidden: true, context: "No Readings", unshowable: true }]
        setParameters(newSensors);
    }

    return (
        <div className="py-4">
            {
                loading ? <div className="flex justify-center items-center h-40 space-x-2">
                    <NinetyRing />
                    <p>Loading Parameters..</p>
                </div>
                    : parameters.filter(i => !i.hidden).length > 0 ? <>
                        <div className="flex flex-row space-x-2 mb-3">{
                            parameters
                                .filter(i => i.hidden)
                                .map(parameter => (
                                    <Badge key={parameter.parameter_id} className={`bg-sky-600 shadow-md ${parameter.unshowable ? "cursor-default hover:bg-sky-600" : "cursor-pointer hover:bg-sky-700"}`}>
                                        {parameter.name} {parameter.context && `(${parameter.context})`}
                                    </Badge>
                                )
                                )
                        }</div>
                        <div className="transition-all grid grid-cols-1 xl:grid-cols-2 gap-4">{
                            parameters
                                .filter(i => !i.hidden)
                                .map(parameter => <Parameter
                                    key={parameter.parameter_id}
                                    parameter={parameter}
                                    hideCallback={(sensor: any) => { }}
                                    emptyCallback={removeSensorCallback} />
                                )
                        }</div>
                    </>
                        : parameters.filter(i => i.hidden).length <= 0 && <p>No parameters found</p>
            }
        </div>
    );
}