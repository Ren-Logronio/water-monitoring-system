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

        // get parameters from the server
        axios.get(`/api/parameter?pond_id=${pond_id}`).then(response => {
            // if no parameters found
            if (!response.data.results || response.data.results.length <= 0) {
                setParameters([]);
                return;
            }
            setParameters(response.data.results.map((i: any) => {
                return i.count > 0 ? { ...i, hidden: false, unshowable: false } : { ...i, hidden: true, context: "No Readings", unshowable: true };
            }));
        }).catch(error => {
            console.error(error);
        }).finally(() => {
            // set loading state to false
            setLoading(false);
        });
    }, [pond_id]);

    const handleHideParameter = (parameter: any) => {
        setParameters(parameters.map((i: any) => {
            return i.parameter_id === parameter.parameter_id ? { ...i, hidden: true } : i;
        }));
    };

    const handleShowParameter = (parameter: any) => {
        setParameters(parameters.map((i: any) => {
            return i.parameter_id === parameter.parameter_id ? { ...i, hidden: false } : i;
        }));
    };

    return (
        <div className="py-4 h-full mt-5">

            {/* while fetching data */}
            {loading &&
                <div className="flex justify-center items-center h-40 space-x-2">
                    <NinetyRing width={40} height={40} />
                </div>
            }

            {/* if data is fetched and has data for parameters */}
            {!loading && parameters.length > 0 &&
                <>
                    {parameters.filter(i => i.hidden).length > 0 &&
                        <div className="flex flex-row space-x-2 mb-10">
                            {parameters
                                .filter(i => i.hidden)
                                .sort((a, b) => Number(a.unshowable))
                                .map(parameter => (
                                    <Badge key={parameter.parameter_id} 
                                        variant={parameter.unshowable ? "secondary" : "default"}
                                        className={`${!parameter.unshowable && "cursor-pointer"}`}
                                        onClick={!parameter.unshowable ? () => {handleShowParameter(parameter)} : () => {}}>
                                        {!parameter.unshowable && <>Show</>} {parameter.name} {parameter.unshowable && <>&nbsp; --</>}
                                    </Badge>
                                )
                                )}
                        </div>
                    }

                    {/* if all parameters have data */}
                    {parameters.filter(i => !i.hidden).length > 0 &&
                        <>
                            <div className="transition-all grid grid-cols-1 xl:grid-cols-2 gap-4">
                                {parameters.filter(i => !i.hidden).map(parameter =>
                                    // render parameter component with data
                                    <Parameter
                                        key={parameter.parameter_id}
                                        parameter={parameter}
                                        hideCallback={handleHideParameter} />
                                )
                                }
                            </div>
                        </>
                    }

                    {/* if all parameters have no data */}
                    {   parameters.filter(i => i.hidden && i.unshowable).length === parameters.length &&
                        <p className="text-xl text-center m-auto">This pond has no data readings yet</p>
                    }

                    {/** if all params are hidden but have data */}
                    {   parameters.filter(i => i.hidden).length === parameters.length &&
                        <p className="text-xl text-center m-auto">No parameters visible, try showing the parameters above</p>
                    }
                </>
            }

            {/* if data is fetched and has no data for parameters */}
            {!loading && parameters.length <= 0 &&
                <p className="text-xl text-center mt-10">No parameters found</p>
            }

        </div>
    );
}